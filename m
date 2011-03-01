Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab1CAO1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 09:27:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:49257 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab1CAO1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:27:43 -0500
Subject: Re: [PATCH 3/6] perf record: add time-of-day option
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de
In-Reply-To: <1298865151-23656-4-git-send-email-daahern@cisco.com>
References: <1298865151-23656-1-git-send-email-daahern@cisco.com>
	 <1298865151-23656-4-git-send-email-daahern@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 15:29:11 +0100
Message-ID: <1298989751.5226.863.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-02-27 at 20:52 -0700, David Ahern wrote:
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 51a2f34..404b1ee 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -240,6 +240,7 @@ struct perf_event_attr {
>  #define PERF_EVENT_IOC_PERIOD          _IOW('$', 4, __u64)
>  #define PERF_EVENT_IOC_SET_OUTPUT      _IO ('$', 5)
>  #define PERF_EVENT_IOC_SET_FILTER      _IOW('$', 6, char *)
> +#define PERF_EVENT_IOC_RECORD_SAMPLE   _IO('$', 7)
>  
>  enum perf_event_ioc_flags {
>         PERF_IOC_FLAG_GROUP             = 1U << 0,
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index a25a63d..7999f55 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -3250,6 +3250,7 @@ static struct perf_event *perf_fget_light(int fd, int *fput_needed)
>  static int perf_event_set_output(struct perf_event *event,
>                                  struct perf_event *output_event);
>  static int perf_event_set_filter(struct perf_event *event, void __user *arg);
> +static int perf_event_generate_sample(struct perf_event *event);
>  
>  static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
> @@ -3296,6 +3297,9 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>         case PERF_EVENT_IOC_SET_FILTER:
>                 return perf_event_set_filter(event, (void __user *)arg);
>  
> +       case PERF_EVENT_IOC_RECORD_SAMPLE:
> +               return perf_event_generate_sample(event);
> +
>         default:
>                 return -ENOTTY;
>         }
> @@ -4398,6 +4402,21 @@ exit:
>         rcu_read_unlock();
>  }
>  
> +/* add a sample to the event stream based on user request */
> +static int perf_event_generate_sample(struct perf_event *event)
> +{
> +       struct perf_sample_data data;
> +       struct pt_regs regs;
> +
> +       perf_fetch_caller_regs(&regs);
> +       event->pmu->read(event);
> +       perf_sample_data_init(&data, 0);
> +       data.period = event->hw.last_period;
> +       perf_event_output(event, 0, &data, &regs);
> +
> +       return 0;
> +}

I'm not quite sure why you need this.. 

