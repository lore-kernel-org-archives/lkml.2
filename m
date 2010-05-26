Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934336Ab0EZG6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 02:58:19 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58692 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934225Ab0EZG6S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 02:58:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=xgpUyXcEVN58xmaUYdsaNznfiR4/tiJizAVMN4j1aFoCUtNL+NOjKZBzmD/YzU3Cq
	eGTZ+3YALkHMBHXyksa4w==
MIME-Version: 1.0
In-Reply-To: <1274855658.3429.24.camel@minggr.sh.intel.com>
References: <4bfbceef.e495e30a.5dae.61b6@mx.google.com>
	<1274794518.5882.1280.camel@twins>
	<AANLkTilEnIrY2HDdxDMdDIfkz8j1ueTbOf0CmD1y14ra@mail.gmail.com>
	<1274796225.5882.1389.camel@twins>
	<AANLkTinTfqLdRbgqRfn4Avl6bedB6xyLbRybwencYRiF@mail.gmail.com>
	<AANLkTimWx4fnqA5hviwv8gOTH1eydC0SMllcmsQp8jSB@mail.gmail.com>
	<1274801531.5882.1670.camel@twins>
	<1274855658.3429.24.camel@minggr.sh.intel.com>
Date: Wed, 26 May 2010 08:58:14 +0200
Message-ID: <AANLkTikZFOVLVIr51D_R8hB2glXp9M70QvQLx0-zKaWO@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix event scheduling issues introduced by 
	transactional API (take 2)
From: Stephane Eranian <eranian@google.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>, "paulus@samba.org" <paulus@samba.org>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "fweisbec@gmail.com" <fweisbec@gmail.com>,
       "acme@infradead.org" <acme@infradead.org>,
       "perfmon2-devel@lists.sf.net" <perfmon2-devel@lists.sf.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 8:34 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> On Tue, 2010-05-25 at 23:32 +0800, Peter Zijlstra wrote:
>> On Tue, 2010-05-25 at 17:02 +0200, Stephane Eranian wrote:
>> > Ok, the patch look good expect it needs:
>> >
>> > static int x86_pmu_commit_txn(const struct pmu *pmu)
>> > {
>> >         ......
>> >         /*
>> >          * copy new assignment, now we know it is possible
>> >          * will be used by hw_perf_enable()
>> >          */
>> >         memcpy(cpuc->assign, assign, n*sizeof(int));
>> >
>> >         cpuc->n_txn = 0;
>> >
>> >         return 0;
>> > }
>> >
>> > Because you always call cancel_txn() even when commit()
>> > succeeds. I don't really understand why. I think it could be
>> > avoided by clearing the group_flag in commit_txn() if it
>> > succeeds. It would also make the logical flow more natural. Why
>> > cancel something that has succeeded. You cancel when you fail/abort.
>>
>> Gah, I forgot about that. I think I suggested to Lin to do that and then
>> promptly forgot.
>
> cancel_txn() clears the transaction flag, so it is needed after both
> success and fail transaction, although the function name is a bit
> misleading.
>
> Peter's patch adds the clear of transaction flag into each
> implementation of ->commit_txn.
>
> So cancel_txn() is only called after fail transaction now.
>
Yes and I think it is less prone to confusion now.
