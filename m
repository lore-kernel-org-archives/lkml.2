Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab0LGVRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 16:17:13 -0500
Received: from smtp-out.google.com ([216.239.44.51]:13845 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab0LGVRL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 16:17:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=SecWFonn8SHWI4CE8lIK+9ni+8Q4ow7WY4gDJE99U74VQ0o6RwfWdCwachR0l3lpKm
         10MoB0T/9cvEZFAl6jgg==
MIME-Version: 1.0
In-Reply-To: <4CFDFCEF.3080708@redhat.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
 <1291421609-14665-8-git-send-email-dhsharp@google.com> <4CF9F7AB.8050802@redhat.com>
 <AANLkTi=H9eSAOKmN8KdKDKiFZdD7DjQC=wa+fqrDpe2q@mail.gmail.com> <4CFDFCEF.3080708@redhat.com>
From: David Sharp <dhsharp@google.com>
Date: Tue, 7 Dec 2010 13:16:48 -0800
Message-ID: <AANLkTinK7Zqh=GfFLeyJLxA4u2ozyVj-Ja435iBJPV13@mail.gmail.com>
Subject: Re: [PATCH 07/15] ftrace: fix event alignment: kvm:kvm_hv_hypercall
To: Avi Kivity <avi@redhat.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, mrubin@google.com,
        kvm-devel <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 7, 2010 at 1:22 AM, Avi Kivity <avi@redhat.com> wrote:
> On 12/06/2010 10:38 PM, David Sharp wrote:
>> On Sat, Dec 4, 2010 at 12:11 AM, Avi Kivity<avi@redhat.com>  wrote:
>> >  On 12/04/2010 02:13 AM, David Sharp wrote:
>> >>
>> >>  Signed-off-by: David Sharp<dhsharp@google.com>
>> >>  ---
>> >>    arch/x86/kvm/trace.h |    8 ++++----
>> >>    1 files changed, 4 insertions(+), 4 deletions(-)
>> >>
>> >>  diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
>> >>  index a6544b8..ab41fb0 100644
>> >>  --- a/arch/x86/kvm/trace.h
>> >>  +++ b/arch/x86/kvm/trace.h
>> >>  @@ -62,21 +62,21 @@ TRACE_EVENT(kvm_hv_hypercall,
>> >>          TP_ARGS(code, fast, rep_cnt, rep_idx, ingpa, outgpa),
>> >>
>> >>          TP_STRUCT__entry(
>> >>  -               __field(        __u16,          code            )
>> >>  -               __field(        bool,           fast            )
>> >>                  __field(        __u16,          rep_cnt         )
>> >>                  __field(        __u16,          rep_idx         )
>> >>                  __field(        __u64,          ingpa           )
>> >>                  __field(        __u64,          outgpa          )
>> >>  +               __field(        __u16,          code            )
>> >>  +               __field(        bool,           fast            )
>> >>          ),
>> >>
>> >
>> >  Looks like a pessimisation.
>> >
>> >  Before: 24 bytes
>> >  After: 32 bytes
>> >
>> >  (on a 64-bit machine, assuming no packing)
>>
>> This patch is predicated on packing the event structures. And since
>> the ring buffer is 32-bit addressable, I don't attempt to improve
>> alignment beyond 32-bit boundaries.
>
> I don't understand this.  Can you elaborate?  What does "32-bit addressable"
> mean?

The ring buffer gives you space that is a multiple of 4 bytes in
length, and 32-bit aligned. Therefore it is useless to attempt to
align the structure beyond 32-bit boundaries, eg, a 64-bit boundary,
because it is unpredictable if the memory the structure will be
written to is at a 64-bit boundary (addr % 8 could be 0 or 4).

> And "predicated on packing the event structures"?  Is the structure
> __attribute__((packed)), or is it not?

It is not packed in Linus' tree, but one of the patches before this
patch in this patch series adds __attribute__((packed)). This patch
assumes that the event packing patch has been applied. This patch
should not be applied if the packing patch is not (hence,
"predicated").

>
> --
> error compiling committee.c: too many arguments to function
>
>
