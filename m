Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab1JSTUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 15:20:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56464 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab1JSTUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 15:20:16 -0400
Date: Wed, 19 Oct 2011 17:20:11 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com
Subject: Re: [PATCH] perf top: fix crash on annotate request
Message-ID: <20111019192011.GG2229@ghostprotocols.net>
References: <1319048598-15030-1-git-send-email-dsahern@gmail.com>
 <20111019183848.GE2229@ghostprotocols.net>
 <4E9F1AA0.4010706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9F1AA0.4010706@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 19, 2011 at 12:44:48PM -0600, David Ahern escreveu:
> On 10/19/2011 12:38 PM, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Oct 19, 2011 at 12:23:18PM -0600, David Ahern escreveu:
> >> Hitting an annotate case where src is not set and
> >> perf-top crashes.

> > How did you got there? 
> 
> I was starting perf top, selecting a symbol and pressing 'a'. In the
> crash case it was the perf command itself.

Humm, looks like a race, the old 'perf top --tui' had this:

static void perf_top_browser__annotate(struct perf_top_browser *browser)
{
        struct sym_entry *syme = browser->selection;
        struct symbol *sym = sym_entry__symbol(syme);
        struct annotation *notes = symbol__annotation(sym);
        struct perf_top *top = browser->b.priv;

        if (notes->src != NULL)
                goto do_annotation;

        pthread_mutex_lock(&notes->lock);

        top->sym_filter_entry = NULL;

        if (symbol__alloc_hist(sym, top->evlist->nr_entries) < 0) {
                pr_err("Not enough memory for annotating '%s' symbol!\n",
                       sym->name);
                pthread_mutex_unlock(&notes->lock);
                return;
        }

        top->sym_filter_entry = syme;

        pthread_mutex_unlock(&notes->lock);
do_annotation:
        symbol__tui_annotate(sym, syme->map, 0, top->delay_secs * 1000);
}


Which is not even completely right, the notes->src should happen inside
the lock, like parse_source in the --stdio...

Can you check if that is the problem? I.e. take notes->lock, check if
->src is NULL, if so call symbol__alloc_hist, etc?

- Arnaldo
