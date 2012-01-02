Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab2ABSyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 13:54:49 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:58687 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174Ab2ABSyr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 13:54:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAOesGMgXRev24e0bmGD71J04=Aon7bs0YeK7mwX8Na12uR_b6A@mail.gmail.com>
References: <1325472276.13595.200.camel@deadeye>
	<CAOesGMgXRev24e0bmGD71J04=Aon7bs0YeK7mwX8Na12uR_b6A@mail.gmail.com>
Date: Mon, 2 Jan 2012 10:54:46 -0800
X-Google-Sender-Auth: AA880Cvp6E4qkfq7MRNDJfDI8v0
Message-ID: <CAPnjgZ1fr-aqXBDe8yPGE=aMHkYY6Rr_ArXFWOdYK+qp9HSh4A@mail.gmail.com>
Subject: Re: Circular dependency between <linux/kernel.h> and <asm/bug.h> on ARM
From: Simon Glass <sjg@chromium.org>
To: Olof Johansson <olof@lixom.net>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben, Olof,

On Sun, Jan 1, 2012 at 11:01 PM, Olof Johansson <olof@lixom.net> wrote:
> On Sun, Jan 1, 2012 at 6:44 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
>> Commit 87e040b6456fd3416a1f6831c1eedaef5c0a94ff ("ARM: 7017/1: Use
>> generic BUG() handler") makes BUG() use BUILD_BUG_ON().  However,
>> BUILD_BUG_ON() is not defined in <linux/bug.h> but in <linux/kernel.h>.
>>
>> arch/include/asm/bug.h does not include <linux/kernel.h> and *cannot* do
>> so because the latter already includes <asm/bug.h>.
>
> Sure it can, but it's not ideal. Since the BUILD_BUG_ON is only used
> in bug.h in a #define, it will be resolved below the includes of
> either so there should be no ordering issue between the two.
>
> I coincidentally posted a patch earlier to do just that, I didn't see
> your email until later.
>
>> Maybe BUILD_BUG_ON() should be moved out to a header of its own, or else
>> this particular use should be moved to some other file.  This needs to
>> be fixed somehow, as it obviously leads to build failures, e.g.:
>>
>> https://buildd.debian.org/status/fetch.php?pkg=linux-2.6&arch=armel&ver=3.2~rc7-1~experimental.1&stamp=1325142904
>
> Or perhaps moving BUILD_BUG_ON to include/linux/bug.h?
>
> The quickest fix for now might be to take out the BUILD_BUG_ON(),
> especially so close to 3.2-final.

Yes I like that idea as the check isn't funtional. Perhaps ultimately
the BUILD_BUG_ON check for sizeof(struct bug_entry) should really go
in lib/bug.c. Something like, in the header:

#define GENERIC_BUG_ENTRY_SIZE 12

and then in lib/bug.c:

#ifdef GENERIC_BUG_ENTRY_SIZE
BUILD_BUG_ON(GENERIC_BUG_ENTRY_SIZE != sizeof(struct bug_entry))
#endif

The other more fragile option might be to make sure all files include
<linux/kernel.h>?

Regards,
Simon

>
>
> -Olof
