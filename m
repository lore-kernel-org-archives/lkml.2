Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399Ab0EMQc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:32:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61468 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab0EMQc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:32:56 -0400
X-Authority-Analysis: v=1.1 cv=QBaIlYAip0cLYvdi/Wu3On4+kilSXYulM+a9j4asJ0c= c=1 sm=0 a=r5AvUYk336kA:10 a=GQCbJdZ--msA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VnNF1IyMAAAA:8 a=NWMgqpFGjsOVjBAvD5cA:9 a=Tl8wxLIa536yNiw0khL553MzeuwA:4 a=PUjeQqilurYA:10 a=BUIu5HHrI6x_7vLK:21 a=XbruPtFK5d5rAqkf:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/7] perf trace: Correctly handle arrays
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>
In-Reply-To: <1273730632-21008-3-git-send-email-imunsie@au1.ibm.com>
References: <1273730632-21008-1-git-send-email-imunsie@au1.ibm.com>
	 <1273730632-21008-3-git-send-email-imunsie@au1.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 13 May 2010 12:32:54 -0400
Message-ID: <1273768374.27703.1101.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 16:03 +1000, Ian Munsie wrote:
> From: Ian Munsie <imunsie@au1.ibm.com>
> 
> Previously, perf was assuming that an array from an ftrace event was an
> array of longs, which will not always be the case. Additionally,
> long_size is not even being initialised, so it would fail to read the
> data and would erroneously report that the array was filled with zeroes.
> 
> This patch adds two extra entries into the field structure - arraylen
> and elementsize, so that the code can easily look them up instead of
> assuming that the elements are long_size. The element size is currently
> derived by the size of the entire array and the number of elements
> within the array.
> 
> This problem can be demonstrated with:
> perf record -e raw_syscalls:sys_enter -a sleep 0.1
> perf trace
> 
> Without this patch, output similar to the following is produced:
>  perf-4355  [004]  1871.504685: sys_enter: NR 319 (0, 0, 0, 0, 0, 0)
>  perf-4355  [004]  1871.504723: sys_enter: NR 3 (0, 0, 0, 0, 0, 0)
>  perf-4355  [004]  1871.504733: sys_enter: NR 204 (0, 0, 0, 0, 0, 0)
> 
> After applying this patch, the output looks like:
>  perf-4355  [004]  1871.504685: sys_enter: NR 319 (10247ac0, ffffffff, 5, ffffffff, 0, 107a80d8)
>  perf-4355  [004]  1871.504723: sys_enter: NR 3 (a, ffb6fcf0, 20, ffffffff, 0, 10112c20)
>  perf-4355  [004]  1871.504733: sys_enter: NR 204 (a, 4, 800, 6, 0, 10112c20)
> 
> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> ---
>  tools/perf/util/trace-event-parse.c |   11 ++++++++++-
>  tools/perf/util/trace-event.h       |    2 ++
>  2 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
> index 8f470f6..f360f75 100644
> --- a/tools/perf/util/trace-event-parse.c
> +++ b/tools/perf/util/trace-event-parse.c
> @@ -852,6 +852,9 @@ static int event_read_fields(struct event *event, struct format_field **fields)
>  			field->flags |= FIELD_IS_ARRAY;
>  
>  			type = read_token(&token);
> +			if (test_type(type, EVENT_ITEM))
> +				goto fail;
> +			field->arraylen = strtoul(token, NULL, 0);
>  		        while (strcmp(token, "]") != 0) {
>  				if (last_type == EVENT_ITEM &&
>  				    type == EVENT_ITEM)
> @@ -971,6 +974,11 @@ static int event_read_fields(struct event *event, struct format_field **fields)
>  
>  		free_token(token);
>  
> +		if (field->flags & FIELD_IS_ARRAY)
> +			field->elementsize = field->size / field->arraylen;

Note, if an array also has something like [TASK_COMM_LEN] then arraylen
will be zero, causing a divide by zero exception above.

-- Steve

> +		else
> +			field->elementsize = field->size;
> +
>  		*fields = field;
>  		fields = &field->next;
>  
> @@ -2101,7 +2109,8 @@ static unsigned long long eval_num_arg(void *data, int size,
>  			}
>  			right = eval_num_arg(data, size, event, arg->op.right);
>  			val = read_size(data + larg->field.field->offset +
> -					right * long_size, long_size);
> +					right * larg->field.field->elementsize,
> +					larg->field.field->elementsize);
>  			break;
>  		}
>   default_op:
> diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
> index 406d452..cc58a19 100644
> --- a/tools/perf/util/trace-event.h
> +++ b/tools/perf/util/trace-event.h
> @@ -40,6 +40,8 @@ struct format_field {
>  	char			*name;
>  	int			offset;
>  	int			size;
> +	unsigned int		arraylen;
> +	unsigned int		elementsize;
>  	unsigned long		flags;
>  };
>  


