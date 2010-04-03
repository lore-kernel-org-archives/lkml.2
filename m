Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab0DCNyh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 09:54:37 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38273 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab0DCNye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 09:54:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=XEJ0q05Unh7daY8O7wPd4why/lkX3zlCc105TTxhJ63ctLiJfkTUyunAmggxOF4wsb
         BOhcHhqo8mVkj+f0tYv01CeCAJR1dIjnMhaCh1Dz7KQoDg2b+Ss5IkVVc5qSJo8B5akA
         QPb6XLZ/wrxU+WZ3I7NjsL/gxKUpDG2H05WK0=
Date: Sat, 3 Apr 2010 10:54:28 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       rostedt@goodmis.org, k-keiichi@bx.jp.nec.com
Subject: Re: [RFC v2][PATCH 08/11] perf: convert perf header build_ids into
 build_id events
Message-ID: <20100403135427.GB14310@ghostprotocols.net>
References: <1270184365-8281-1-git-send-email-tzanussi@gmail.com>
 <1270184365-8281-9-git-send-email-tzanussi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270184365-8281-9-git-send-email-tzanussi@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Apr 01, 2010 at 11:59:22PM -0500, Tom Zanussi escreveu:
> Bypasses the build_id perf header code and replaces it with a
> synthesized event and processing function that accomplishes the same
> thing, used when reading/writing perf data to/from a pipe.

>  static void atexit_header(void)
>  {
> -	session->header.data_size += bytes_written;
> +	if (!pipe_output) {
> +		session->header.data_size += bytes_written;
> -	process_buildids();
> -	perf_header__write(&session->header, output, true);
> +		process_buildids();
> +		perf_header__write(&session->header, output, true);
> +	} else {
> +		int err;
> +		err = event__synthesize_build_ids(process_synthesized_event,
> +						  session);
> +		if (err < 0)
> +			pr_err("Couldn't synthesize build ids.\n");

Humm, getting everything as events looks elegant, but for the buildid
case... when processing samples we need to _first_ have the build-ids,
hence they are in the header.

We only generate them after collecting all samples because it would
disturb the system if we look at them in the ELF files when we get
PERF_RECORD_MMAP events.

In live mode we will be resolving symbols as we get samples, so I fail
to see how synthesizing the build-ids as a last step will help.

With build-ids events we can at least generate it in advance for the
kernel and modules, as it is a restriced number of DSOs and we have them
easily accessible via /sys, but for the userspace bits...

- Arnaldo
