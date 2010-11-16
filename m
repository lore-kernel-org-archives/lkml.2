Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab0KPPSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 10:18:09 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60201 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab0KPPSH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 10:18:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=N8t8t9Zpvx0i1fCbcN6NJiP+B56V5igQJEt52DSqA4Y8otcg5mWc5I2Iyh1Z1GmHSL
         7IVEl08e+82IefF51TuoFFjlXpemAfkO/W3rtCQC7/7sWgn1PLM0LYxmEVxglPvr/3s7
         hh1sRkRwvTM9kcuxox87ywRjWi8RDunNNXhq8=
MIME-Version: 1.0
In-Reply-To: <20101115183014.GD31421@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
	<1289584840-18097-6-git-send-email-catalin.marinas@arm.com>
	<20101115183014.GD31421@n2100.arm.linux.org.uk>
Date: Tue, 16 Nov 2010 15:18:03 +0000
X-Google-Sender-Auth: PQzsoYa0zIcOqWOPCR5pHmxXsaA
Message-ID: <AANLkTikCVCuR2mxyoE7e=V_FauTxztLHUJp97+rroUe-@mail.gmail.com>
Subject: Re: [PATCH v2 05/20] ARM: LPAE: Introduce L_PTE_NOEXEC and L_PTE_NOWRITE
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 November 2010 18:30, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Nov 12, 2010 at 06:00:25PM +0000, Catalin Marinas wrote:
>> The LPAE page table format needs to explicitly disable execution or
>> write permissions on a page by setting the corresponding bits (similar
>> to the classic page table format with Access Flag enabled). This patch
>> introduces null definitions for the 2-level format and the actual noexec
>> and nowrite bits for the LPAE format. It also changes several PTE
>> maintenance macros and masks.
>>
>> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>> ---
>>  arch/arm/include/asm/pgtable-2level.h |    2 +
>>  arch/arm/include/asm/pgtable.h        |   44 +++++++++++++++++++++------------
>>  arch/arm/mm/mmu.c                     |    6 ++--
>>  3 files changed, 33 insertions(+), 19 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/pgtable-2level.h b/arch/arm/include/asm/pgtable-2level.h
>> index 36bdef7..4e21166 100644
>> --- a/arch/arm/include/asm/pgtable-2level.h
>> +++ b/arch/arm/include/asm/pgtable-2level.h
>> @@ -128,6 +128,8 @@
>>  #define L_PTE_USER           (1 << 8)
>>  #define L_PTE_EXEC           (1 << 9)
>>  #define L_PTE_SHARED         (1 << 10)       /* shared(v6), coherent(xsc3) */
>> +#define L_PTE_NOEXEC         (0)
>> +#define L_PTE_NOWRITE                (0)
>
> Let's not make this more complicated than it has to be.  If we need the
> inverse of WRITE and EXEC, then that's what we should change everyone to,
> not invent a new system to work along side the old system.

This adds an additional instruction in set_pte_ext, unless you can
write the bit checking in a better way:

	tst	r1, #L_PTE_NOWRITE
	orrne	r3, r3, #PTE_EXT_APX
	tsteq	r1, #L_PTE_DIRTY
	orreq	r3, r3, #PTE_EXT_APX

-- 
Catalin
