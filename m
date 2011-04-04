Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab1DDUm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 16:42:56 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61805 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab1DDUmz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 16:42:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pOqptJLokh2JFMN6l+tpGq4oTsXZ0HND3lDrjZ0WhEU3NNUu2YsBjdMRB57zHT/r3h
         CclSkiOVDfbv6DxYaHAe1BAEJjbvDojgYBtA3IYeuxqyZYvHX3LY4t/KFwUk08Rj69xy
         UETD9PCjSN5OePy9TOxq/U+vicCgz5z3cGaZo=
MIME-Version: 1.0
In-Reply-To: <BANLkTik_MNB+4vWXw2k0-B-2B1_4MO3HMg@mail.gmail.com>
References: <BANLkTinVd8-VNM+uJ0HReA3cd6DaF-wA=A@mail.gmail.com>
	<20110404194230.GA8785@sucs.org>
	<BANLkTik_MNB+4vWXw2k0-B-2B1_4MO3HMg@mail.gmail.com>
Date: Tue, 5 Apr 2011 00:42:54 +0400
Message-ID: <BANLkTi=oZ8a8EwbraRm4n-wjmyrLe+MySg@mail.gmail.com>
Subject: Re: [REGRESSION] 2.6.39-rc1: f23eb2b breaks console output
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 April 2011 23:59, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Mon, Apr 4, 2011 at 12:42 PM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
>> On Mon, Apr 04, 2011 at 11:15:10PM +0400, Alexander Beregalov wrote:
>>>
>>> commit f23eb2b2b28547fc70df82dd5049eb39bec5ba12 tty: stop using
>>> "delayed_work" in the tty layer
>>> breaks console output for me.
>>
>> Same here - doing a dmesg in an xterm makes the machine hang for about
>> 10 seconds and latencytop whinges that a raw SCSI command took 4000ms to
>> complete (uniprocessor x86 EeePC 900).
>>
>> Additionally, you won't see this problem if you have CONFIG_PREEMPT set
>> but as my config has CONFIG_PREEMPT_VOLUNTARY=y I do see this problem.
>> Reverting f23eb2b2b28547fc70df82dd5049eb39bec5ba12 fixed the problem for
>> me too.
>
> Does this patch make a difference?
Yes, it works on top of 2.6.39-rc1-00184-g78fca1b9
Thanks
>
> The tty ldisc flushing code had this crazy "reflush if we're full"
> logic, which was apparently hiding a problem in N_TTY handling where
> it wouldn't wake things up when the receive-room was opened up again.
>
> When I made it not do timers, the "reflush" logic basically made for
> an infinite loop (before, it used to instead basically poll for the
> event on each timer tick instead).
>
> The attached patch removes the reflush logic, and makes N_TTY instead
> wake up the work when opening up the receive buffer again.
>
>               Linus
>
