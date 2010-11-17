Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911Ab0KQVdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 16:33:05 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62364 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137Ab0KQVdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 16:33:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=V2cb8Bq3NYn21eJiqu6Ol1wvuhodqHiMcItClKvLNKiQ+khhGvkWQxa54k+A1Jbh+R
         jNigQhgRBOfIkaKS8A/LGQwTEqBtbCjTHeXDOYmOvu9j/ozmp1bv1YXeV/1vteoDzZe7
         Yzw0KSQYF15T1ZxWMQEXbGJr67rTRsqGkpnKk=
Date: Thu, 18 Nov 2010 00:32:46 +0300
From: Dan Carpenter <error27@gmail.com>
To: Nils Radtke <Nils.Radtke@Think-Future.de>, gregkh@suse.de,
        kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: wlan-ng: p80211netdev.c cleanup
Message-ID: <20101117213246.GJ31724@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Nils Radtke <Nils.Radtke@Think-Future.de>, gregkh@suse.de,
	kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1284834652-26171-1-git-send-email-lkml@Think-Future.com>
 <20100918204112.GA6236@bicker>
 <20101117145548.GA6794@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117145548.GA6794@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't want to be rude, but it's basically a kernel hacker rule that
after you introduce a bug (and your last cleanup patch did) that you
have to fix a bug to make up for it.  One excellent source of easy bugs
is using static checkers.

I've found a static checker bug for you.

drivers/staging/comedi/drivers/usbdux.c +1488
	usbdux_ao_inttrig(38) warn: inconsistent returns sem:&this_usbduxsub->sem:
	locked (1468) unlocked (1457,1462,1479,1488) 

Here are some questions to help guide you.

1)  Does it look like a bug?
2)  Who introduced the bug and in which commit?
	Use: "git log -p" and "git blame"
	If it's a real bug and you fix it, by deductive reasoning that
	means you are smarter than the person who introduced it.
3)  What is the return code on line 1468?
4)  Is it a special case where the caller handles it differently?
	Use cscope for this.
	make cscope
	Use "cscope -d" for speed.
	Configure vim to use cscope.
	:cs find c inttrig
	^] takes you back a step.
	cscope is an essential kernel hacking tool.
5)  usbdux_ai_inttrig() is basically the same as usbdux_ao_inttrig().
    Does the ai version ever return with a lock held?
6)  What are the implications if we return with the lock held?
7)  How is the bug triggered?
8)  Can the user trigger the bug?
9)  Can a regular user trigger the bug or only root?
	I sometimes have to use google for this to try figure out how
	people set up the permissions.
10) Should this go into the -stable kernel?

You don't have to answer all the questions, just enough to know what the
correct fix is.  You can fix a different bug if you want to...  It
doesn't matter so long as it is at least equal to the bug you
introduced.

regards,
dan carpenter

PS:

> - When checking skb for NULL, which one is better? (I suppose the former one)
>   skb == NULL or !skb 
>   Rewrite occurrences of the other one for cleanup?

You shouldn't even think about changing these.  But in new code then
!skb is better as Al Viro explains in this email:
http://lwn.net/Articles/331593/

