Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab1LVAvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:51:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598Ab1LVAv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:51:28 -0500
Date: Wed, 21 Dec 2011 16:51:14 -0800
From: Greg KH <gregkh@suse.de>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: RFC: android logger feedback request
Message-ID: <20111222005114.GA22541@suse.de>
References: <4EF264C3.6000104@am.sony.com>
 <20111221231956.GB23859@suse.de>
 <4EF27B85.9080801@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF27B85.9080801@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 04:36:21PM -0800, Tim Bird wrote:
> On 12/21/2011 03:19 PM, Greg KH wrote:
> > That all describes the current code, but you haven't described what's
> > wrong with the existing syslog interface that requires this new driver
> > to be written.  And why can't the existing interface be fixed to address
> > these (potential) shortcomings?
> 
> 
> >> One specific question I have is where is the most appropriate
> >> place for this code to live, in the kernel source tree?
> >> Other embedded systems might want to use this system (it
> >> is simpler than syslog, and superior in some ways), so I don't
> >> think it should remain in an android-specific directory.
> > 
> > What way is it superior?
> 
> Here are some ways that this code is superior to syslog:
> 
> Speed and overhead
> ------------------
> syslogd requires a separate user-space process to manage
> the log area, where this code does not.  The overhead
> for any user-space process is at least 16K, and usually much
> more than this (not including the size of the log storage
> area).  On one of my embedded systems, where syslogd is
> provided by busybox, the unique set size for syslogd
> is 96K.  This code, built in to the Linux kernel is less
> than 4K code and data (again, not including the size of
> the log storage area).

Huh, I'm not talking about syslogd, I'm talking about the syslog(2)
syscall we have.

This character interface seems very close to the syslog(2) api, but just
done in a character interface, with ioctls, which also require userspace
tools to manage properly, so I fail to see the big "gain" here.

What am I missing?

> To deliver a message to syslog requires a socket operation
> and a few context switches.

For syslog(2)?  What socket?

> With the logger code,
> the operation is a file operation (writev) to kernel memory,
> with only one context switch into and out of the kernel.

I think we are thinking of different apis here...

> No dependence on persistent storage
> -----------------------------------
> syslogd requires either persistent storage to store the log,
> or a network connection to an outside device.  Being
> purely memory-based, the logger requires neither of these.
> With logger, persistence of the log data is left to the
> implementor.  In Android, the data is delivered over a USB
> connection via adb or to the console as ascii text, using
> logcat.  In other embedded systems, other mechanisms might
> be used if long-term storage of the messages is desired.
> With logger, there is no automatic notion of on-device
> persistent storage for the log data.
> 
> No dependence on networking kernel code
> ---------------------------------------
> The syslog communication mechanism requires sockets.  This
> prevents one from configuring the kernel with no networking
> support, which is sometimes done in embedded systems to save
> size.
> 
> Simpler constraint on log size
> ------------------------------
> The busybox syslog daemon uses a log rotation feature to constrain
> the size of the log in persistent storage.  This is overly
> cumbersome in both speed and complexity compared to the logger's
> simple ring buffer.
> 
> Licensing
> ---------
> The code implementing library and command line tool support
> for this logger (in user space) is available under an Apache license,
> rather than a GPL license, which is desirable for some vendors.

Ok, care to rewrite all of this when thinking of syslog(2), the kernel
system call, and not syslogd, which is what I was not comparing this
kernel driver to at all?

> > How does this tie into Kay
> > and Lennard's proposal for work in this area?
> 
> It does not tie in at all.
> 
> Kay and Lennart's proposal for "the Journal" creates
> a more complex system than syslog, and handles a number
> of new interesting use cases.  This system is on the
> opposite side of the spectrum from the journal, towards
> simplicity and reduced footprint and overhead.

No, it's much the same, for the kernel side, which is what I am
referring to here.

greg k-h
