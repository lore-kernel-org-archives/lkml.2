Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab1G2SvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 14:51:06 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:45377 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1G2SvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 14:51:04 -0400
Subject: Re: recursive locking: epoll.
From: Paul Bolle <pebolle@tiscali.nl>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Davide Libenzi <davidel@xmailserver.org>,
        Nelson Elhage <nelhage@ksplice.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, davidel@xmailserver.org,
        Dave Jones <davej@redhat.com>
Date: Fri, 29 Jul 2011 20:50:55 +0200
In-Reply-To: <1311249346.2098.12.camel@t41.thuisdomein>
References: <4E1FF63F.4040704@gmail.com> <20110715210420.GA22551@redhat.com>
	 <1311249346.2098.12.camel@t41.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.3 (3.1.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1311965462.2351.28.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sent to the addresses get_maintainer.pl suggested and to Davide and
Nelson, because this is about code they cared about half a year ago.
CC'ed to the addresses involved until now.)

On Thu, 2011-07-21 at 13:55 +0200, Paul Bolle wrote:
> That number turned out to be 722472
> ( https://bugzilla.redhat.com/show_bug.cgi?id=722472 ).

0) This seems to be a lockdep false alarm. The cause is an epoll
instance added to another epoll instance (ie, nesting epoll instances).
Apparently lockdep isn't supplied enough information to determine what's
going on here. Now there might be a number of ways to fix this. But
after having looked at this for quite some time and updating the above
bug report a number of times, I guessed that involving people outside
those tracking that report might move things forward towards a solution.
At least, I wasn't able to find a, well, clean solution.

1) The call chain triggering the warning with the nice
    *** DEADLOCK ***

line can be summarized like this:

sys_epoll_ctl
    mutex_lock                          epmutex
    ep_call_nested
        ep_loop_check_proc
            mutex_lock                      ep->mtx
            mutex_unlock                    ep->mtx
    mutex_lock                              ep->mtx
    ep_eventpoll_poll
        ep_ptable_queue_proc
        ep_call_nested
            ep_poll_readyevents_pro
                ep_scan_ready_list
                    mutex_lock                  ep->mtx
                    ep_read_events_proc
                    mutex_unlock                ep->mtx
    mutex_unlock                            ep->mtx
    mutex_unlock                        epmutex

2) When ep_scan_ready_list() calls mutex_lock(), lockdep notices
recursive locking on ep->mtx. It is not supplied enough information to
determine that the lock is related to two separate epoll instances (the
outer instance and the nested instance). The solution appears to involve
supplying lockdep that information (ie, "lockdep annotation"). 

3) Please see the bugzilla.redhat.com report for further background.


Paul Bolle

