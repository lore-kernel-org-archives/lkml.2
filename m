Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab0H3Lix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 07:38:53 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64897 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab0H3Liw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 07:38:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Zd3rR3BaH5VLXEK1ORLu4RYNX9yJ2zBBAEPRfId6cWSQLnCCX5N1QG8bBYDRBSiW/x
         o512a2eqJ2PgSWHX5wbAocw6v+vKIPG8zEVylR9z1aAuebJ20/PNfO9jXsuhGYp6RopP
         yHj/8MriIO3/j0hy6K4fkzeWH5nfSW7epmDm4=
MIME-Version: 1.0
In-Reply-To: <AANLkTikcZ1sWe4+j+Q6nw7ZNy-fi-=ojdvnZP5+N+QQY@mail.gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
	<1283011478-27237-7-git-send-email-brgerst@gmail.com>
	<AANLkTi=G+=Hc3e8Z+HH6yJPGi4TM3TyYZ6UvdUpHyBsC@mail.gmail.com>
	<AANLkTinVQFHG1nh5XBd1tJ29fBDjQc=QRThXySiPWd2q@mail.gmail.com>
	<AANLkTikcZ1sWe4+j+Q6nw7ZNy-fi-=ojdvnZP5+N+QQY@mail.gmail.com>
Date: Mon, 30 Aug 2010 07:38:51 -0400
Message-ID: <AANLkTinFbWiu5zuHJJ6OVB8AbsWjgqdiJatrfkT7M6Wk@mail.gmail.com>
Subject: Re: [PATCH 06/11] x86-64: Fix %cs value in convert_from_fxsr()
From: Brian Gerst <brgerst@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 2:44 AM, Pekka Enberg <penberg@kernel.org> wrote:
> On Sat, Aug 28, 2010 at 7:04 PM, Brian Gerst <brgerst@gmail.com> wrote:
>>>> While %ds still contains the userspace selector, %cs is KERNEL_CS
>>>> at this point.  Always get %cs from pt_regs.
>>>>
>>>> It actually is possible to get the correct segments for compat tasks,
>>>> but that involves using the [f]xsave instruction without a REX.W prefix.
>>>>
>>>> Signed-off-by: Brian Gerst <brgerst@gmail.com>
>
> On Sun, Aug 29, 2010 at 2:41 PM, Pekka Enberg <penberg@kernel.org> wrote:
>>> It might be just me but the above description doesn't explain
>>> anything. What's the problem here? What is this fixing?
>
> On Mon, Aug 30, 2010 at 3:25 AM, Brian Gerst <brgerst@gmail.com> wrote:
>> The %cs segment being reported to a compat task is flat out wrong.  It
>> is getting KERNEL_CS when it should be some userspace segment.  The
>> code segment may still be wrong, because the %cs in pt_regs may not
>> have been the segment where the instruction that flagged the exception
>> executed from.  That could be fixed by using fxsave without a REX.W
>> prefix when saving the state of compat tasks, which would save the
>> segment and 32-bit offset instead of the 64-bit offset for the code
>> and data pointers.  This is such a corner case that it probably isn't
>> worth putting much effort into fixing unless someone demonstrates a
>> real need for it.
>
> I sort of was able to deduce most of that from the original
> description. However, I still don't quite understand what the problem
> causes. Just a wrong cs reported to a signal handler or something
> else?
>

The wrong cs value is reported to userspace.  I don't know of any apps
that actually cares about it, except for possibly wine or dosemu.  In
any app that doesn't use alternate segments, the above fix will be
give the correct cs every time (since it never changes).

--
Brian Gerst
