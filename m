Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992560Ab2KOCUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 21:20:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10258 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423510Ab2KOCUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 21:20:40 -0500
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ejdjjcuyxB0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=kQC1szw6xFsA:10 a=1XWaLZrsAAAA:8 a=GuKw-04RjQq1jgg0djgA:9 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=yPbhu7vWmWay-X1A:21 a=s2-sj-32hG1-cRuc:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1352946038.18025.87.camel@gandalf.local.home>
Subject: Re: [PATCH 2/4] kernel-shark: Allow unsetting of all CPUs in filter
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Wed, 14 Nov 2012 21:20:38 -0500
In-Reply-To: <1352944274-21699-2-git-send-email-dhsharp@google.com>
References: <1352944274-21699-1-git-send-email-dhsharp@google.com>
	 <1352944274-21699-2-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-14 at 17:51 -0800, David Sharp wrote:
> From: Vaibhav Nagarnaik <vnagarnaik@google.com>
> 
> The button "All CPUs" in CPU filter dialog allows setting of all CPUs
> but doesn't clear CPUs when it is unchecked. Make sure that when the
> "All CPUs" button is unchecked, all the CPUs get unchecked.
> 
> Tested: In kernelshark, go to Filter->list CPUs and uncheck "All CPUs"
> button. All the CPUs should be unchecked at that point.

This was actually done purposely, as I thought it may be used as a way
to change to a mode to select individual CPUs.

But I'm fine with having it do this feature, except...

Now when I apply this patch, if I go to deselect a CPU, it unselects the
"All CPUs" and causes all CPUs to be unselected.

Need to make it so it only unselects all CPUs if it was directly
unselected. Not when its done by deselecting a single CPU.

So, I'm going to NAK this patch, but if you can fix it so that
deselecting the "All CPUs" directly has this feature, but I can still
deselect a single CPU without it causing all other CPUs to be
deselected, then I'm fine with the change.

-- Steve

> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> Signed-off-by: David Sharp <dhsharp@google.com>
> ---
>  trace-filter.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/trace-filter.c b/trace-filter.c
> index c657a18..89cf032 100644
> --- a/trace-filter.c
> +++ b/trace-filter.c
> @@ -1723,12 +1723,10 @@ void cpu_toggle(gpointer data, GtkWidget *widget)
>  
>  	if (strcmp(label, CPU_ALL_CPUS_STR) == 0) {
>  		cpu_helper->allcpus = active;
> -		if (active) {
> -			/* enable all toggles */
> -			for (cpu = 0; cpu < cpu_helper->cpus; cpu++)
> -				gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(cpu_helper->buttons[cpu]),
> -							     TRUE);
> -		}
> +		/* enable/disable all toggles */
> +		for (cpu = 0; cpu < cpu_helper->cpus; cpu++)
> +			gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(cpu_helper->buttons[cpu]),
> +						     active ? TRUE : FALSE);
>  		return;
>  	}
>  


