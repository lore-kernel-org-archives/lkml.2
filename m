Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab2FAGlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 02:41:53 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46059 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757784Ab2FAGlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 02:41:52 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205311342320.2764@chino.kir.corp.google.com>
References: <1338438844-5022-1-git-send-email-andi@firstfloor.org>
	<alpine.DEB.2.00.1205311342320.2764@chino.kir.corp.google.com>
Date: Fri, 1 Jun 2012 09:41:51 +0300
X-Google-Sender-Auth: 2K1XtElIjg2APZiVXKz3eE8Wh2I
Message-ID: <CAOJsxLHz7sJytDdDsjXCP4VaR2AFu_dDJchHQuceB11wMGN+Yg@mail.gmail.com>
Subject: Re: [PATCH] slab/mempolicy: always use local policy from interrupt
 context v3
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, cl@linux.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 11:45 PM, David Rientjes <rientjes@google.com> wrote:
> On Wed, 30 May 2012, Andi Kleen wrote:
>
>> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
>> index cfb6c86..b65eb06 100644
>> --- a/mm/mempolicy.c
>> +++ b/mm/mempolicy.c
>> @@ -1586,9 +1586,11 @@ static unsigned interleave_nodes(struct mempolicy *policy)
>>   * task can change it's policy.  The system default policy requires no
>>   * such protection.
>>   */
>> -unsigned slab_node(struct mempolicy *policy)
>> +unsigned slab_node(void)
>>  {
>> -     if (!policy || policy->flags & MPOL_F_LOCAL)
>> +     struct mempolicy *policy = current->mempolicy;
>> +
>> +     if (in_interrupt() || !policy || policy->flags & MPOL_F_LOCAL)
>>               return numa_node_id();
>>
>>       switch (policy->mode) {
>
> I think the version proposed by David Mackey is more clear, it makes it
> obvious that we don't want to dereference current in interrupt context
> whereas that relies on short-circuiting your conditional in your approach.

I like it better also. Christoph, Andi?
