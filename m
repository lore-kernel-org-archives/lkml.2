Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab0FPJZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 05:25:06 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46728 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab0FPJZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 05:25:04 -0400
X-AuditID: b753bd60-a9cd2ba000005dcc-48-4c18986de75d
Message-ID: <4C189868.8050900@hitachi.com>
Date: Wed, 16 Jun 2010 18:24:56 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jason Baron <jbaron@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Ingo Molnar <mingo@elte.hu>, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [Dle-develop] [PATCH -tip v3 3/5] x86: Introduce	text_poke_smp_batch()
 for	batch-code modifying
References: <20100519165305.31828.15577.stgit@localhost6.localdomain6>	<20100519165326.31828.43183.stgit@localhost6.localdomain6> <20100615121804.GA5342@nowhere>
In-Reply-To: <20100615121804.GA5342@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Wed, May 19, 2010 at 12:53:26PM -0400, Masami Hiramatsu wrote:
>> Introduce text_poke_smp_batch(). This function modifies several
>> text areas with one stop_machine() on SMPr. Because calling
>> stop_machine() is heavy task, it is better to aggregate text_poke
>> requests.
>>
>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Jim Keniston <jkenisto@us.ibm.com>
>> Cc: Jason Baron <jbaron@redhat.com>
>> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> <snip>
>> +/**
>> + * text_poke_smp_batch - Update instructions on a live kernel on SMP
>> + * @params: an array of text_poke parameters
>> + * @n: the number of elements in params.
>> + *
>> + * Modify multi-byte instruction by using stop_machine() on SMP. Since the
>> + * stop_machine() is heavy task, it is better to aggregate text_poke requests
>> + * and do it once if possible.
>> + *
>> + * Note: Must be called under get_online_cpus() and text_mutex.
>> + */
>> +void __kprobes text_poke_smp_batch(struct text_poke_param *params, int n)
>> +{
>> +	struct text_poke_params tpp = {.params = params, .nparams = n};
>> +
>> +	atomic_set(&stop_machine_first, 1);
>> +	wrote_text = 0;
>> +	stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
>> +}
> 
> 
> Looks good. But wouldn't it be even better to get stop_machine()
> be able to support batches itself?
> 
> We could have stop_machine_queue() and stop_machine_flush(),
> stop_machine() would be a shortcut for both, to execute single jobs,
> may be that could simplify some code here and there.
> 

Ah, that's nice too :) But I don't know other people who need
that interfaces. Would you know there are any other potential users?

Thank you,
