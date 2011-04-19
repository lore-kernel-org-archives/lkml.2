Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab1DSVQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:16:32 -0400
Received: from smtp-out.google.com ([74.125.121.67]:53064 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab1DSVQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:16:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ea9GUZtmlPLsPVGEa42Xs2olrLYMLzuYRdiw0YtKS05smj4N6+VbHqw9uzDOOUg4uF
         pnhPDwo9JAu6VFJ1AScA==
MIME-Version: 1.0
In-Reply-To: <1303240935.8345.7.camel@twins>
References: <BANLkTi=g6iPgdctAmuZ=bb8J6FqNJA-vZQ@mail.gmail.com>
	<1303240935.8345.7.camel@twins>
Date: Tue, 19 Apr 2011 21:16:27 +0000
Message-ID: <BANLkTi=GX3JGw-Dq+ejsCguV0A+9w2eCjQ@mail.gmail.com>
Subject: Re: [BUG] perf_event: sampling buffer format cannot handle
 multi-event sampling
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, mingo@elte.hu,
        Paul Mackerras <paulus@samba.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 7:22 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2011-04-19 at 19:10 +0000, Stephane Eranian wrote:
>> Hi,
>>
>> I was looking at the sampling buffer format and I think there is an
>> issue in case
>> one samples on more than one event at a time and each event as a different
>> sample_type value (i.e., what it wants to record in each sample).
>>
>> The sample_type is exported per-event by the API. In order to decode a sample
>> (PERF_RECORD_SAMPLE) one has to know which event caused it. To identify
>> the event, one has to include PERF_SAMPLE_ID in the sample_type. Each such
>> id uniquely identifies an event. Assuming the tool keeps a mapping of event to
>> ID, we can then reconstruct. This is what perf does.
>>
>> The problem is that to extract the event ID, one has to already parse the sample
>> itself. That means, you need sample_type to extract the event ID.
>>
>> Thus, we have a catch 22 situation.
>>
>> Looking at the perf tool, it sort of works today simply because the
>> same sample_type
>> is applied to all events.
>>
>> To solve this, we could either:
>>    - add the event ID to the header for PERF_RECORD_SAMPLE
>>    - enforce event ID is systematically saved at the beginning on
>> PERF_RECORD_SAMPLE
>>
>> None of those options is transparent, I am afraid, unless we introduce
>> new record types.
>
> Or simply don't mix different sample_types in the same buffer?
>
Does the kernel disallow this when you merge the output via that ioctl()?
