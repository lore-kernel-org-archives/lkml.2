Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab0FOMSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 08:18:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43123 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab0FOMSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 08:18:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tf/800BSpn14/Dpf385o/Vv7b8+WPecgU/vht+AuLzwdxsZ6HdPgasutvWO5Onc+gP
         gGArjJcmkW+v6bkWLVMjp6ESQ7EgL5nAgoXd20bz4ix5oSt86J/YqQIsm1y6Cswr00yj
         xbcce+a2Es+3u0i6uIOOyHT4KQfwAxr22iL64=
Date: Tue, 15 Jun 2010 14:18:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -tip v3 3/5] x86: Introduce text_poke_smp_batch() for
	batch-code modifying
Message-ID: <20100615121804.GA5342@nowhere>
References: <20100519165305.31828.15577.stgit@localhost6.localdomain6> <20100519165326.31828.43183.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519165326.31828.43183.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 12:53:26PM -0400, Masami Hiramatsu wrote:
> Introduce text_poke_smp_batch(). This function modifies several
> text areas with one stop_machine() on SMPr. Because calling
> stop_machine() is heavy task, it is better to aggregate text_poke
> requests.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Jim Keniston <jkenisto@us.ibm.com>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
<snip>
> +/**
> + * text_poke_smp_batch - Update instructions on a live kernel on SMP
> + * @params: an array of text_poke parameters
> + * @n: the number of elements in params.
> + *
> + * Modify multi-byte instruction by using stop_machine() on SMP. Since the
> + * stop_machine() is heavy task, it is better to aggregate text_poke requests
> + * and do it once if possible.
> + *
> + * Note: Must be called under get_online_cpus() and text_mutex.
> + */
> +void __kprobes text_poke_smp_batch(struct text_poke_param *params, int n)
> +{
> +	struct text_poke_params tpp = {.params = params, .nparams = n};
> +
> +	atomic_set(&stop_machine_first, 1);
> +	wrote_text = 0;
> +	stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
> +}


Looks good. But wouldn't it be even better to get stop_machine()
be able to support batches itself?

We could have stop_machine_queue() and stop_machine_flush(),
stop_machine() would be a shortcut for both, to execute single jobs,
may be that could simplify some code here and there.

