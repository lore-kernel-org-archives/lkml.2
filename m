Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708Ab0JGPNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 11:13:00 -0400
Received: from smtp-out.google.com ([216.239.44.51]:53409 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab0JGPM7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 11:12:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PlSM6hUPXyrB3Pl/PU2E4w3Xy9nPsODIcghZKtUq0yyiu6KxCZvrC2lHLTn1tNilNg
         LlE7u0qpck+h/h4zUs9w==
MIME-Version: 1.0
In-Reply-To: <4CADD257.7080203@zytor.com>
References: <1286212172-654419-1-git-send-email-hans.rosenfeld@amd.com>
	<alpine.LFD.2.00.1010042358520.2556@localhost6.localdomain6>
	<20101005145155.GD173@escobedo.osrc.amd.com>
	<alpine.LFD.2.00.1010051730060.2556@localhost6.localdomain6>
	<20101005182739.GE173@escobedo.osrc.amd.com>
	<20101005190501.GA21916@elte.hu>
	<20101006073558.GJ13563@erda.amd.com>
	<AANLkTi=T0QmcKeZcgcR+GKk-9OwQUB_x8XdHiNuU7tE_@mail.gmail.com>
	<AANLkTimwVuosF24_gBOTpMydfcj-SQPFyZM4uu=vEPbL@mail.gmail.com>
	<4CADD257.7080203@zytor.com>
Date: Thu, 7 Oct 2010 17:12:54 +0200
Message-ID: <AANLkTin64ZU+JiBpG7=hivVxGQ4k4-w9zQVPGmEouAfA@mail.gmail.com>
Subject: Re: [RFC 0/3] Basic support for LWP
From: Stephane Eranian <eranian@google.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@elte.hu, Hans.Rosenfeld@amd.com, robert.richter@amd.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Andreas.Herrmann3@amd.com, peterz@infradead.org, fweisbec@gmail.com,
        rostedt@goodmis.org, acme@redhat.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 7, 2010 at 3:59 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/07/2010 03:46 AM, Stephane Eranian wrote:
>>
>> As for the patch itself, I am not an expert at xsave/xrstor, but it seems to
>> me you could decouple LWP from FPU. I think  Brian had the same comment.
>> I suspect this can be done and it will certainly look cleaner.
>>
>
> Well, once you're using XSAVE you're not decoupled from the FPU.  Worse,
> if you're using XSAVE and not honoring CR0.TS you have a major design flaw.
>
I looked at the LWP documentation and it says:

"LWP does not support the “lazy” state save and restore that is
possible for floating point and SSE state. It does not interact with
the CR0.TS bit. Operating systems that support LWP must always do an
XSAVE to preserve the old thread’s LWP context and an XRSTOR to set up
the new LWP context. The OS can continue to do a lazy switch of the FP
and SSE state by ensuring that the corresponding bits in EDX:EAX are
clear when it executes the XSAVE and XRSTOR to handle the LWP
context."

They imply that you can still do lazy FP/SSE save/restore even though
CR0.TS does not monitor LWP access.

If LWP is used the kernel needs to call xsave/xrstor on ctxsw. It can
do this lazily by checking LWP_CBADDR.
