Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab0GVUIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 16:08:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55887 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab0GVUIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 16:08:46 -0400
X-Authority-Analysis: v=1.1 cv=0ETVU5ClxBlG/P3Ky9ZuhqraSVIot/cIDNO6awFX9oc= c=1 sm=0 a=G2SHEswpWIAA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=enOvQawGAAAA:8 a=zIT8YLJ741Ot2pXwb2QA:9 a=LivhYNbawXdkvDJ_j7JCW-FBFxwA:4 a=PUjeQqilurYA:10 a=bkT6KWdcy0IA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] trace-cmd: Don't SIGSEGV when event field format
 cannot be parsed.
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1279046692-11941-1-git-send-email-ddaney@caviumnetworks.com>
References: <1279046692-11941-1-git-send-email-ddaney@caviumnetworks.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 22 Jul 2010 16:08:45 -0400
Message-ID: <1279829325.3319.27.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-13 at 11:44 -0700, David Daney wrote:
> >From the MIPS kernel we get things like:
> 
> print fmt: "page=%p pfn=%lu order=%d migratetype=%d", REC->page, ({ struct page *__pg = (REC->page); int __sec = page_to_section(__pg); (unsigned long)(__pg - __section_mem_map_addr(__nr_to_section(__sec))); }), REC->order, REC->migratetype
> 
> This cannot be parsed, leading to a NULL struct event_format* being
> passed to pevent_get_common_field_val, which produces a SIGSEGV.  It
> would be good to get a parsable format from the kernel, but to
> remediate the problem for legacy kernels, we can just return an error
> indicator in this case.  This allows some output from trace-cmd
> report, although perhaps with some missing data.  But this is better
> than crashing.
> 
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> ---
>  parse-events.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/parse-events.c b/parse-events.c
> index 9d5a3fa..16fff12 100644
> --- a/parse-events.c
> +++ b/parse-events.c
> @@ -4481,6 +4481,9 @@ int pevent_get_common_field_val(struct trace_seq *s, struct event_format *event,
>  {

To be consistent, probably all the pevent_get_*field* should test for
null event.

Did you want to resend a patch that does that?

-- Steve

>  	struct format_field *field;
>  
> +	if (!event)
> +		return -1;
> +
>  	field = pevent_find_common_field(event, name);
>  
>  	return get_field_val(s, field, name, record, val, err);


