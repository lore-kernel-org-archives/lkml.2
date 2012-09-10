Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab2IJRXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:23:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46584 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab2IJRXr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:23:47 -0400
Message-ID: <1347297816.2124.48.camel@twins>
Subject: Re: [PATCH 1/3] perf tool: precise mode requires exclude_guest
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Date: Mon, 10 Sep 2012 19:23:36 +0200
In-Reply-To: <1347295216-1202-2-git-send-email-dsahern@gmail.com>
References: <1347295216-1202-1-git-send-email-dsahern@gmail.com>
	 <1347295216-1202-2-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-10 at 10:40 -0600, David Ahern wrote:
> PEBS cannot be used with guest mode. See:
>    https://lkml.org/lkml/2012/7/9/264

Expanding and not relying on external stuff is so much better.

So in particular you want something like:

"Intel PEBS in VT-x context uses the DS address as a guest linear
address, even though its programmed by the host as a host linear
address. This either results in guest memory corruption and or the
hardware faulting and 'crashing' the virtual machine

Therefore we have to disable PEBS on VT-x enter and re-enable on VT-x
exit, enforcing a strict exclude_guest.

AMB IBS does work but doesn't currently support exclude_* at all,
setting an exclude_* bit will make it fail.

 ... explain how one can use IBS if we auto-fallback to !precise ..."

Hmm ?

> If user adds :p modifier set exclude_guest as well.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Robert Richter <robert.richter@amd.com>
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: Avi Kivity <avi@redhat.com>
> ---
>  tools/perf/util/parse-events.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index a031ee1..f2c02b2 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -694,6 +694,9 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
>  			eH = 0;
>  		} else if (*str == 'p') {
>  			precise++;
> +			/* use of precise requires exclude_guest */
> +			if (!exclude_GH)
> +				eG = 1;
>  		} else
>  			break;
>  

