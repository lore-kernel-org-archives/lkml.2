Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab0DAMqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 08:46:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53296 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab0DAMpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 08:45:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Date: Thu, 1 Apr 2010 14:45:32 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <20100331172208.GB5163@nowhere> <4BB485ED.80806@s5r6.in-berlin.de>
In-Reply-To: <4BB485ED.80806@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004011445.32657.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19r89Tl0kB2/0SKHjW+clrq6OTK7Sm9SdCSJiO
 C4S5XNGcZ11vN/dWAh6aFMWs0f2GcxU67diAcXXoLH5MyIbyTR
 FmxcDXxO7YbQABrP5pS1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 April 2010, Stefan Richter wrote:
> > 
> > I wonder if we should actually just turn all these into unlocked_ioctl
> > directly. And then bring a warn on ioctl, and finally schedule the removal
> > of this callback.
> 
> A side note:  A considerable portion of this particular commit in Arnd's
> git actually does not deal with .ioctl->.unlocked_ioctl at all, but
> purely with .llseek.  Many(?) of these changes deal with .ioctl and
> .llseek together.  (Arnd also says so in the last paragraph of his
> changelog.)
> 
> IOW there are less .ioctl implementations left than one could think from
> a look at the diffstat.

Given our recent discussions on the llseek topic, it's probably better to
revert most of the changes that purely deal with llseek. My current idea
is to use an explicit default_llseek only if one of the following is given:

- we convert ioctl to unlocked_ioctl in the same file_operations, or
- the module uses the big kernel lock explicitly elsewhere.

Even then, there may be a number of cases where we can show it not
to be necessary, e.g. when the driver does not care about f_pos.
Concurrent llseek is racy by nature, so in most drivers, using the
BKL in llseek does not gain anything over using i_mutex.

	Arnd
