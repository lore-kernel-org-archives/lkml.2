Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab1FFRdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:33:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50421 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab1FFRdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:33:01 -0400
Date: Mon, 6 Jun 2011 19:32:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, acme@redhat.com
Subject: Re: [PATCH] perf: fix missing event name init for default event
Message-ID: <20110606173251.GJ2391@elte.hu>
References: <20110606151024.GA9464@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606151024.GA9464@quad>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> @@ -87,6 +87,13 @@ int perf_evlist__add_default(struct perf_evlist *evlist)
>  	if (evsel == NULL)
>  		return -ENOMEM;
>  
> +	/* use strdup() because free(evsel) assumes name is allocated */
> +	evsel->name = strdup("cycles");
> +	if (!evsel->name) {
> +		free(evsel);
> +		return -ENOMEM;
> +	}
> +
>  	perf_evlist__add(evlist, evsel);
>  	return 0;
>  }

Hm, nice fix, but this function should really follow the standard 
exception tear-down sequence pattern we use in the kernel:

  	if (evsel == NULL)
		goto err;

	...

	if (!evsel->name)
		goto err_free;

	...

	return 0;

err_free:
	free(evsel);
err:
	return -ENOMEM;

Thanks,

	Ingo
