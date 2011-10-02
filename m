Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab1JBQpE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 12:45:04 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:34385 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab1JBQo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 12:44:59 -0400
Date: Sun, 2 Oct 2011 09:44:56 -0700
From: mark gross <markgross@thegnar.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, markgross@thegnar.org,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Subject: [markgross@thengar.org: [RFC] wake up notifications and suspend
 blocking (aka more wakelock stuff)]
Message-ID: <20111002164456.GC14312@mgross-G62>
Reply-To: markgross@thegnar.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

resending to wider list for discussion
----- Forwarded message from mark gross <markgross@thengar.org> -----

Subject: [RFC] wake up notifications and suspend blocking (aka more wakelock stuff)
Date: Tue, 20 Sep 2011 13:33:05 -0700
From: mark gross <markgross@thengar.org>
To: linux-pm@lists.linux-foundation.org
Reply-To: markgross@thegnar.org
Cc: arve@android.com, markgross@thegnar.org, Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org, farrowg@sg.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>

The following patch set implement an (untested) solution to the
following problems.

1) a method for making a system unable to suspend for critical sections
of time.

2) providing a race free method for the acknowledgment of wake event
processing before re-entry into suspend can happen.

It is my opinion that hardship of the infamous wake lock patches and
subsequent time sink is the conflation of these two needs that any
system that wakes from suspend if automatic suspend and wake ups is
going to work.

The android wake lock way of solving these issues is bit of a one off
for selected subsystems (alarm and input WRT notification of wake
events) and I don't think they generalize well and makes it hard to hand
off wake lock critical sections between kernel and user mode without
having a timeout interface (which is by definition racy).

I think by explicitly separating these two requirements and building on
the new-ish wakeup.c code thats in today's kernels we can come close to
solving these needs.

The following patches explicitly address these 2 issues without
conflating them with each other.  Because notification is very different
from defining a critical section and confusing them is a bad idea.  I
like the directness of each and hope these will help get people focused
on the problem definition more than the implementation.  (mine or anyone
else's)

Also note the attached python programs below that attempt to show how
the ABI's could be used:

pms.py -- stub program of a power manager service that hits /sys/power/*
interface  (code is incomplete but gets the idea across)

dont_sleep.py -- show how a process could block suspending using the pm_qos
interface in patch 2.

button-wake.py -- shows how the wake events should be handled WRT patch
1.

--mark


Signed-off-by: markgross <markgross@thegnar.org>



#!/user/bin/python

#
# python program to talk to /dev/pwrButton misc device to make sure 
# the wakeup.c complaint user mode power manager doesn't re-enter suspend
# before this python program say's "OK"
# assumptions:
# pwrbutton driver registers a wakeup source with name "pwrButton"
# user mode power manager follows wakeup.c defined protocol of reading
# /sys/power/wake_count and writing to back to it before writing to
# /sys/power/state.  (the read is blocking if wakeup event is "active")



import struct

def Notification():
    iofile = open("/dev/pwrButton", "rw")
    # blocking select
    iofile.select()
    count = iofile.read()
    print "detected wake event now doing important stuff"
    # now its time to ACK the wake event(s) so another suspend can happen.
    # this will unblock the read of /sys/power/wake_count so the next suspend
    # can be attempted.
    print "acknowledge wake event(s)"
    iofile.write(count * '.')
    iofile.flush()
    iofile.close()


def main():
    while True:
        Notification()


if "__main__" == __name__:
    main()



#!/usr/bin/python

# power manager service program for implementing aggressive power management 
# policies of sleeping when no other program has a request to not sleep.
# Basically a python program that implement Android power management
# Applications can hold user mode "partial" and "full" wake locks.
# Partial wake locks prevent suspending but allow the display to turn off.
# full wake locks keep the display on.
# applications grab and release wakelocks through a d-bus (?) interface defined 
# by this python program.  TBD

import thread
import time

partial_wake_locks = []
full_wake_locks = []

def screen_off(off):
    if off:
        #turn off display and back light
        return
    else:
        #turn on display and back light
        return


def suspend_thread():
    global partial_wake_locks
    global full_wake_locks
    stateIO = open("/sys/power/state", "rw")
    countIO = open("/sys/power/wakeup_count", "rw")
    while True:
        #grab thread lock here
        if len(partial_wake_locks) == 0 and len(full_wake_locks) == 0:
        # release thread lock
            wakeup_count = countIO.read() #blocks until previous wakeup has been acknowledged
            countIO.write(wakeup_count)
            countIO.flush()
            #double check that no locks are held after maybe waking up.
            #grab thread lock here
            if len(partial_wake_locks) == 0 and len(full_wake_locks) == 0:
            # release thread lock
                stateIO.write("mem")
                stateIO.flush()
            else:
                # release thread lock
                continue
        else:
            # release thread lock
            continue
        
        time.sleep(1.0)


def dbus_thread():
    # update partial and full wake lock lists based on dbus activities
    # hold thread lock when updating lists...
    if len(partial_wake_locks) == 0:
    # release thread lock
        screen_off(0)
    else:
        # release thread lock
        screen_off(1)

    return

def main():
    return
    #init stuff and kick off do_Dbus and suspend threads
    # just sit and wait for something to happen.
    # do a join wait on for either of the two child threads to complete

if "__main__" == __name__:
    main()



#!/user/bin/python

#
# python program to talk to /dev/suspend_block to make sure system doesn't
# suspend in a critical section of code.
#

import struct, time


def main():
    iofile = open("/dev/suspend_block", "w")
    s = struct.pack('=i', 1)
    iofile.write(s)
    iofile.flush()
    while 1:
        time.sleep(10.0)

    iofile.close()

if "__main__" == __name__:
    main()




----- End forwarded message -----
