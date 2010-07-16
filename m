Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433Ab0GPWxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 18:53:42 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56043 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab0GPWxk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 18:53:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L5qN2pcf25A54jeeEZV0QVEqI3RX74kYw3skx88ij5XJDa0fqPwqO4WysECjN2yeGR
         wYKCsffeLvpba2Tg8+3BnmKatBVii4XDDPgq1rmknJ1kvDm/kQiumWkSYeebm6aRZh1B
         +D9dktgreHh4ERjZTFxgsrELKJUOiiibD3Z8A=
MIME-Version: 1.0
In-Reply-To: <AANLkTimWRnHDnpS1x53aaCN_wJDYrRR3EpEXEc6ZReXF@mail.gmail.com>
References: <AANLkTineI34tKDMPYN4SPY0W432cv8ZPc55IEW5hwmed@mail.gmail.com>
	<AANLkTikwWezvqiW-ts__stLfofKbaqG8CSzOYvDQuxhu@mail.gmail.com>
	<AANLkTimWRnHDnpS1x53aaCN_wJDYrRR3EpEXEc6ZReXF@mail.gmail.com>
Date: Fri, 16 Jul 2010 16:53:38 -0600
Message-ID: <AANLkTintOTo_y6naaaQwPg6dBDpetApWhAbkrdu_u7Sy@mail.gmail.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Well, the way I handled this problem on NetWare SMP and that other
> kernel was to create a pool of TSS descriptors and reload each during
> the exception to swap stacks before any handlers were called.  Allowed
> it to nest until I ran out of TSS descriptors (64 levels).  Not sure
> that's the way to go here though but it worked on that case.
>
> Jeff
>

Here is where that old dusty code lives these days - it deals with this problem.

http://open-source-netware.googlecode.com/files/manos-06-26-2010.tar.gz

file to look at is startup.386

;
;   nmi entry code
;

nmi_entry     macro
	cli
	push    ebx
	push    ebp
	mov     ebp, esp
	sub     ebp, SIZE TaskStateSegment
	mov     ebx, ebp

	mov     [ebp].tSS, ss
	mov     [ebp].tGS, gs         ; save segment registers
	mov     [ebp].tFS, fs
	mov     [ebp].tES, es
	mov     [ebp].tDS, ds
	pop     [ebp].tEBP
	mov     [ebp].tEDI, edi
	mov     [ebp].tESI, esi
	mov     [ebp].tEDX, edx
	mov     [ebp].tECX, ecx
	pop     [ebp].tEBX
	mov     [ebp].tEAX, eax

	pop     [ebp].tEIP            ; remove return address
	pop     eax
	mov     [ebp].tCS, ax
	pop     [ebp].tSystemFlags    ; get flags into TSS

	mov     [ebp].tESP, esp       ; save true stack address
	mov     esp, ebx            ; cover stack frame

	mov     eax, CR0
	and     eax, 0FFFFFFF7h     ; clear task switch bit in CR0 to
	mov     CR0, eax            ; avoid NPX exceptions

	xor	eax, eax
	mov	dr7, eax            ; disable breakpoints

	mov     eax, CR3            ;
	mov     [ebp].tCR3, eax     ;
	mov     eax, DebuggerPDE
	mov     CR3, eax

	;
	;   if we do not clear the NESTED_TASK_FLAG, then the IRET
	;   at the end of this function will cause
	;   an invalid TSS exception to be generated because the
	;   task busy bit was cleared earlier
	;

	pushfd
	and	dword ptr [esp], NOT (NESTED_TASK_FLAG OR SINGLE_STEP_FLAG)
	or	dword ptr [esp], RESUME_FLAG
	popfd

	mov     eax, 0FFFFFFFFh    ; mark as a non-pooled TSS exception
	push    eax

	push    0
	push    0
	push    ebp

	endm

;
;   TSS entry code
;


task_entry     macro
	LOCAL   @TSSNotNested, @NoLTR
	LOCAL   @UsedDefaultSegment
	LOCAL   @UsedPooledSegment
	LOCAL   @EnterTheDebugger

	cli
	xor    eax, eax
	str    ax
	mov    esi, offset SystemGDTTable
	mov    esi, dword ptr [esi + 2]
	lea    ebx, [esi + eax]
	mov    al, [ebx].TSSBase2
	mov    ah, [ebx].TSSBase3
	shl    eax, 16
	mov    ax, [ebx].TSSBase1

	;
	;  eax -> TSS Segment (Current)
	;  ebx -> TSS Descriptor (Current)
	;

	movzx  ecx, word ptr [eax].tBackLink
	or     ecx, ecx
	jz     @TSSNotNested

	mov    esi, offset SystemGDTTable
	mov    esi, dword ptr [esi + 2]
	lea    edx, [esi + ecx]
	mov    cl, [edx].TSSBase2
	mov    ch, [edx].TSSBase3
	shl    ecx, 16
	mov    cx, [edx].TSSBase1

	mov    ebp, ecx

	;
	;  edx -> TSS Descriptor (Previous)
	;  ebp -> TSS Segment (Previous)
	;
	;  clear busy state and reset TSS
	;

	mov     [edx].TSSType, 10001001b

@TSSNotNested:
	mov     [ebx].TSSType, 10001001b

	lgdt    ds: SystemGDTTable     ; reset GDT TSS Busy bit

	movzx   eax, word ptr [eax].tBackLink
	or      eax, eax
	jz      @NoLTR

	ltr     ax

@NoLTR:

	mov     eax, CR0
	and     eax, 0FFFFFFF7h     ; clear task switch bit in CR0 to
	mov     CR0, eax            ; avoid NPX exceptions

	xor	eax, eax
	mov	dr7, eax            ; disable breakpoints

	pushfd
	and	dword ptr [esp], NOT (NESTED_TASK_FLAG OR SINGLE_STEP_FLAG)
	or	dword ptr [esp], RESUME_FLAG
	popfd

	push    ebp
	call    AllocPooledResource
	pop     ebp

	or      eax, eax
	jz      @UsedDefaultSegment

	lea     ebp, [eax].TSSSegment
	mov     esp, [eax].StackTop

	push    eax                   ; push address of pooled resource
	jmp     @UsedPooledSegment

@UsedDefaultSegment:
	mov     eax, 0FFFFFFFFh       ; push non-pooled marker onto the stack
	push    eax

@UsedPooledSegment:

	push    0
	mov     eax, CR2    ; get fault address
	push    eax
	push    ebp         ;  pass the TSS

	endm

;
;  TSS exit code
;

Jeff
