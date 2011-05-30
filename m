Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab1E3Upv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 16:45:51 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:41536 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab1E3Upu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 16:45:50 -0400
Date: Mon, 30 May 2011 22:45:48 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Very high CPU values in top on idle system (3.0-rc1)
Message-ID: <20110530204548.GA1762@x4.trippels.de>
References: <20110530173916.GA1746@x4.trippels.de>
 <1306778743.23844.5.camel@twins>
 <20110530182356.GA1762@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110530182356.GA1762@x4.trippels.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.05.30 at 20:23 +0200, Markus Trippelsdorf wrote:
> On 2011.05.30 at 20:05 +0200, Peter Zijlstra wrote:
> > On Mon, 2011-05-30 at 19:39 +0200, Markus Trippelsdorf wrote:
> > > I get very high CPU values when I run 'top' on my (mostly) idle system
> > > with 3.0-rc1. For example mpd was always in the 1-2% range and is now
> > > constantly over 50%. 
> > > 
> > > This is caused by:
> > > 
> > > commit 317f394160e9beb97d19a84c39b7e5eb3d7815a8
> > > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Date:   Tue Apr 5 17:23:58 2011 +0200
> > > 
> > >     sched: Move the second half of ttwu() to the remote cpu
> > > 
> > > When I revert the above I see sane CPU values again.
> > 
> > So: echo NO_TTWU_QUEUE > /debug/sched_features, also cures it?
> 
> Yes.
> 
> > What architecture, what .config, and can you see it with anything other
> > than mpd (yum search mpd, only seems to result in mpd clients not the
> > actual server).
> 
> Yes, mpd was just an example. _Every_ program that would normally show in
> the 1-5% CPU range is now in the 30-70% range (X, xterm, etc.).

IOW:

% sudo echo TTWU_QUEUE >| /sys/kernel/debug/sched_features
% top -b -n 1
top - 22:40:38 up  1:46, 11 users,  load average: 0.00, 0.02, 0.05
Tasks: 109 total,   1 running, 108 sleeping,   0 stopped,   0 zombie
Cpu(s):  1.0%us,  0.9%sy,  0.0%ni, 98.0%id,  0.1%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   8183132k total,  1365724k used,  6817408k free,     1632k buffers
Swap:  2097148k total,        0k used,  2097148k free,   655208k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  881 mpd       20   0  122m  20m 4832 S   74  0.3   4:25.22 mpd
 1564 root      20   0 99428  40m 4716 S   36  0.5   3:36.15 X
 1648 markus    20   0 1147m 340m  39m S   16  4.3   1:17.90 firefox-bin
 1649 markus    20   0  237m  33m  17m S    6  0.4   1:02.31 konsole

% sudo echo NO_TTWU_QUEUE >| /sys/kernel/debug/sched_features
% top -b -n 1
top - 22:42:07 up  1:48, 11 users,  load average: 0.00, 0.01, 0.05
Tasks: 110 total,   1 running, 109 sleeping,   0 stopped,   0 zombie
Cpu(s):  1.0%us,  0.9%sy,  0.0%ni, 98.0%id,  0.1%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   8183132k total,  1377308k used,  6805824k free,     1632k buffers
Swap:  2097148k total,        0k used,  2097148k free,   659896k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 1649 markus    20   0  237m  33m  17m S    2  0.4   1:17.69 konsole
    1 root      20   0   160   28   12 S    0  0.0   0:16.95 minit
    2 root      20   0     0    0    0 S    0  0.0   0:00.36 kthreadd


-- 
Markus
