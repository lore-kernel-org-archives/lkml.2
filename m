Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab2EIDiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 23:38:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10751 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab2EIDiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 23:38:04 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=0in4RCm__d4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=Nma7w3rrDWtLwQp3n5kA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336534682.14207.197.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v7 1/3] trace: Make removal of ring buffer pages atomic
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Laurent Chavey <chavey@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org
Date: Tue, 08 May 2012 23:38:02 -0400
In-Reply-To: <1336096792-25373-1-git-send-email-vnagarnaik@google.com>
References: <1335388704-26790-1-git-send-email-vnagarnaik@google.com>
	 <1336096792-25373-1-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 18:59 -0700, Vaibhav Nagarnaik wrote:

> +		get_online_cpus();
> +		/*
> +		 * Fire off all the required work handlers
> +		 * Look out for offline CPUs
> +		 */
> +		for_each_buffer_cpu(buffer, cpu) {
> +			cpu_buffer = buffer->buffers[cpu];
> +			if (!cpu_buffer->nr_pages_to_update ||
> +			    !cpu_online(cpu))
> +				continue;
> +
> +			schedule_work_on(cpu, &cpu_buffer->update_pages_work);
> +		}
> +		/*
> +		 * This loop is for the CPUs that are not online.
> +		 * We can't schedule anything on them, but it's not necessary
> +		 * since we can change their buffer sizes without any race.
> +		 */
> +		for_each_buffer_cpu(buffer, cpu) {
> +			cpu_buffer = buffer->buffers[cpu];
> +			if (!cpu_buffer->nr_pages_to_update ||
> +			    cpu_online(cpu))
> +				continue;
> +
> +			rb_update_pages(cpu_buffer);
>  		}

BTW, why the two loops and not just:

		for_each_buffer_cpu(buffer, cpu) {
			cpu_buffer = buffer->buffers[cpu];
			if (!cpu_buffer->nr_pages_to_update)
				continue;

			if (cpu_online(cpu))
				schedule_work_on(cpu, &cpu_buffer->update_pages_work);
			else
				rb_update_pages(cpu_buffer);
		}

??


>  
>  		/* wait for all the updates to complete */
>  		for_each_buffer_cpu(buffer, cpu) {
>  			cpu_buffer = buffer->buffers[cpu];
> -			if (cpu_buffer->nr_pages_to_update) {
> -				update_pages_handler(cpu_buffer);
> -			}
> +			if (!cpu_buffer->nr_pages_to_update||

			      !cpu_buffer->nr_pages_to_update ||

-- Steve

> +			    !cpu_online(cpu))
> +				continue;
> +
> +			wait_for_completion(&cpu_buffer->update_completion);
> +			/* reset this value */
> +			cpu_buffer->nr_pages_to_update = 0;
>  		}


