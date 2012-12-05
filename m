Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab2LEA0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 19:26:18 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54396 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab2LEA0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 19:26:14 -0500
MIME-Version: 1.0
In-Reply-To: <1354617854-25296-2-git-send-email-serban.constantinescu@arm.com>
References: <1354617854-25296-1-git-send-email-serban.constantinescu@arm.com>
	<1354617854-25296-2-git-send-email-serban.constantinescu@arm.com>
Date: Tue, 4 Dec 2012 16:26:11 -0800
Message-ID: <CAMP5Xgf-HC7Lk=mOE-7prksbOu886q2=YMC8PvS2vFu1L9D1ow@mail.gmail.com>
Subject: Re: [PATCH 1/2] Staging: android: binder: Add support for 32bit
 binder calls in a 64bit kernel
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        ccross@android.com, zach.pfeffer@linaro.org, Dave.Butcher@arm.com,
        Dianne Hackborn <hackbod@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 4, 2012 at 2:44 AM, Serban Constantinescu
<serban.constantinescu@arm.com> wrote:
> Android's IPC, Binder, does not support calls from a 32-bit userspace
> in a 64 bit kernel. This patch adds support for syscalls coming from a
> 32-bit userspace in a 64-bit kernel.
>

It also seems to remove support for 64-bit user-space in a 64 bit
kernel at the same time. While we have not started fixing this problem
yet, it is not clear that we want to go in this direction. If we want
to have any 64 bit user-space processes, the 32-bit processes need to
use 64 bit pointers when talking to other processes. It may make more
sense to change the user-space binder library to probe for needed
pointer size (either by adding an ioctl to the driver to return the
pointer size in an ioctl with a fixed size pointer or by calling
BINDER_VERSION with the two pointer sizes you support (assuming long
and void * are the same size)).

> Most of the changes were applied to types that change sizes between
> 32 and 64 bit world. This will also fix some of the issues around
> checking the size of an incoming transaction package in the ioctl
> switch. Since  the transaction's ioctl number are generated using
> _IOC(dir,type,nr,size), a different userspace size will generate
> a different ioctl number, thus switching by _IOC_NR is a better
> solution.
>

I don't understand this change. If you use _IOC_NR you lose the
protection that the _IOC macros added. If the size does not match you
still dereference the pointer using the size that the kernel has
(expect where you added a new size check to replace the one you
removed).

-- 
Arve Hjønnevåg
