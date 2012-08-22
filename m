Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab2HVNvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 09:51:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17879 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab2HVNvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 09:51:47 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=y4_MwtkCpzwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=7oBhDXmhtT0A:10 a=meVymXHHAAAA:8 a=3nbZYyFuAAAA:8 a=2_iZOdTX86vzLTjPE0gA:9 a=PUjeQqilurYA:10 a=EvKJbDF4Ut8A:10 a=7VTBkE94ufjHmbvn:21 a=YOML1XKTIJ_mkiLh:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345643505.5069.36.camel@gandalf.local.home>
Subject: Re: [PATCH 3/5] trace-cmd: Support trace-agent of virtio-trace
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Amit Shah <amit.shah@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@amd64.org>,
        "Franch Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        yrl.pp-manager.tt@hitachi.com
Date: Wed, 22 Aug 2012 09:51:45 -0400
In-Reply-To: <20120822084322.17293.70186.stgit@ltc189.sdl.hitachi.co.jp>
References: <20120822084251.17293.69086.stgit@ltc189.sdl.hitachi.co.jp>
	 <20120822084322.17293.70186.stgit@ltc189.sdl.hitachi.co.jp>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-22 at 17:43 +0900, Yoshihiro YUNOMAE wrote:
> Add read path and control path to use trace-agent of virtio-trace.
> When we use trace-agent, trace-cmd will be used as follows:
> 	# AGENT_READ_DIR=/tmp/virtio-trace/tracing \
> 	  AGENT_CTL=/tmp/virtio-trace/agent-ctl-path.in \
> 	  TRACING_DIR=/tmp/virtio-trace/debugfs/tracing \\

Ha! You used "TRACING_DIR" but patch one introduces TRACE_DIR. Lets
change this to DEBUG_TRACING_DIR instead anyway.

Also, I don't like the generic environment variables. Perhaps
VIRTIO_TRACE_DIR, or AGENT_TRACE_DIR and AGENT_TRACE_CTL. Lets try to
keep the environment namespace sparse.

> 	  trace-cmd record -e "sched:*"
> Here, AGENT_READ_DIR is the path for a reading directory of virtio-trace,
> AGENT_CTL is a control path of trace-agent, and TRACING_DIR is a debugfs path
> of a guest.
> 
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> ---
> 
>  trace-cmd.h      |    1 +
>  trace-recorder.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  trace-util.c     |   18 +++++++++++++++++
>  3 files changed, 75 insertions(+), 1 deletions(-)
> 
> diff --git a/trace-cmd.h b/trace-cmd.h
> index f904dc5..75506ed 100644
> --- a/trace-cmd.h
> +++ b/trace-cmd.h
> @@ -72,6 +72,7 @@ static inline int tracecmd_host_bigendian(void)
>  }
>  
>  char *tracecmd_find_tracing_dir(void);
> +char *guest_agent_tracing_read_dir(void);
>  
>  /* --- Opening and Reading the trace.dat file --- */
>  
> diff --git a/trace-recorder.c b/trace-recorder.c
> index 215affc..3b750e9 100644
> --- a/trace-recorder.c
> +++ b/trace-recorder.c
> @@ -33,6 +33,7 @@
>  #include <unistd.h>
>  #include <ctype.h>
>  #include <errno.h>
> +#include <stdbool.h>
>  
>  #include "trace-cmd.h"
>  
> @@ -43,6 +44,8 @@ struct tracecmd_recorder {
>  	int		page_size;
>  	int		cpu;
>  	int		stop;
> +	int		ctl_fd;
> +	bool		agent_existing;

Thanks for the reminder. I need to convert a lot to use 'bool' instead.

>  };
>  
>  void tracecmd_free_recorder(struct tracecmd_recorder *recorder)
> @@ -59,11 +62,29 @@ void tracecmd_free_recorder(struct tracecmd_recorder *recorder)
>  	free(recorder);
>  }
>  
> +static char *use_trace_agent_dir(char *ctl_path,
> +					struct tracecmd_recorder *recorder)
> +{
> +	ctl_path = strdup(ctl_path);
> +	if (!ctl_path)
> +		die("malloc");
> +	warning("Use environmental control path: %s\n", ctl_path);

s/Use/Using/

-- Steve

> +
> +	recorder->ctl_fd = open(ctl_path, O_WRONLY);
> +	if (recorder->ctl_fd < 0)
> +		return NULL;
> +
> +	recorder->agent_existing = true;
> +
> +	return guest_agent_tracing_read_dir();
> +}
> +


