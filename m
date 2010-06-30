Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab0F3TPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 15:15:42 -0400
Received: from sprinkles.athenacr.com ([64.95.46.210]:52925 "EHLO
	sprinkles.inp.in.athenacr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756529Ab0F3TPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 15:15:40 -0400
Message-ID: <4C2B97D7.60303@athenacr.com>
Date: Wed, 30 Jun 2010 15:15:35 -0400
From: Brian Bloniarz <bmb@athenacr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Larry Woodman <lwoodman@redhat.com>, linux-kernel@vger.kernel.org,
       riel@redhat.com, Mark Lord <kernel@teksavvy.com>,
       stefan.bader@canonical.com, kees@ubuntu.com
Subject: Re: Race in wb_do_writeback() ???
References: <1277843296.3223.98.camel@dhcp-100-19-198.bos.redhat.com> <20100629202650.GA28992@infradead.org>
In-Reply-To: <20100629202650.GA28992@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2010 04:26 PM, Christoph Hellwig wrote:
> On Tue, Jun 29, 2010 at 04:28:16PM -0400, Larry Woodman wrote:
>> Chistoph, I am seeing slabcache corruption.  wb_do_writeback() calls
>> wb_clear_pending() which can queue up the freeing of the bdi_work. Then
>> it calls wb_writeback() which can block, resulting in using the bdi_work
>> after its freed.
>> 
>> ------------------------------------------------------------------
>>   /*
>>    * If this isn't a data integrity operation, just notify
>>    * that we have seen this work and we are now starting it.
>>    */
>>   if (!test_bit(WS_ONSTACK, &work->state))
>>          wb_clear_pending(wb, work);
>> 
>>   wrote += wb_writeback(wb, &args);
>> 
>>  /*
>>   * This is a data integrity writeback, so only do the
>>   * notification when we have completed the work.
>>   */
>>   if (test_bit(WS_ONSTACK, &work->state))
>>          wb_clear_pending(wb, work);
>> ------------------------------------------------------------------
>> 
>> Can you have one unconditional call to wb_clear_pending() after the
>> calling wb_writeback()???
> 
> In fact we should only have a conditional call after wb_writeback.
> I've done that already and it's in Jens' tree for 2.6.36:
> 
>   http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=79338d2a78ab78efdc1698f1309766a039addf9d

Hi Christoph, 

Is this a problem that was introduced by your writeback patch
series which just got merged for 2.6.35?
Are you going to try to get a fix for this into 2.6.35?

(CCing some people who were interested in your writeback series).
