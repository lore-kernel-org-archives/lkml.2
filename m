Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272Ab2BJNcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:32:09 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50388 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab2BJNcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:32:07 -0500
Date: Fri, 10 Feb 2012 11:31:59 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH 1/2] perf-tool: Don't process samples with no valid
 machine object
Message-ID: <20120210133159.GF2526@infradead.org>
References: <1328803659-30449-1-git-send-email-joerg.roedel@amd.com>
 <1328803659-30449-2-git-send-email-joerg.roedel@amd.com>
 <20120209163441.GD2526@infradead.org>
 <20120209171334.GR22598@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120209171334.GR22598@amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 09, 2012 at 06:13:34PM +0100, Joerg Roedel escreveu:
> On Thu, Feb 09, 2012 at 02:34:41PM -0200, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Feb 09, 2012 at 05:07:38PM +0100, Joerg Roedel escreveu:
> > > -		if (event->header.type == PERF_RECORD_SAMPLE) {
> > > +		if (event->header.type == PERF_RECORD_SAMPLE && machine != NULL) {
> > 
> > Shouldn't we warn the user, even if just once, on the status (last line
> > on the screen) line?
> 
> Probably yes, what would be a good message? I guess something like
> 
> 	"no machine object for sample"
> 
> is not helpful to the user. Maybe something like
> 
> 	"Unresolvable sample(s) recorded"?
> 
> Or something completly different?

This is not completely standardized or harminized across the sources,
but we have things like:

	if (verbose)
		error("Failed to resolve callchain.  Skipping\n");

---

        if (perf_event__preprocess_sample(event, machine, &al, sample,
                                          NULL) < 0) {
                error("problem processing %d event, skipping it.\n",
                        event->header.type);
                return;
        }

---

       if (!ip_callchain__valid(sample->callchain, event)) {
                pr_debug("call-chain problem with event, skipping it.\n");
                ++session->hists.stats.nr_invalid_chains;

---


	What has been done more recently is like the above, account the
number of different problems and then, at the end do like:

        if (session->hists.stats.nr_unknown_id != 0) {
                ui__warning("%u samples with id not present in the header\n",
                            session->hists.stats.nr_unknown_id);
        }


	But this is for perf report or other tools that process all
events and then provide some post processed results, just before
presenting these results.

	I guess we could do that too for 'perf top' like tools, that
continuously show results while collecting more. Perhaps call
ui__warning() if some threshold happens, i.e. if way too many errors of
some kind are happening and then at the end provide a summary of errors
found.

- Arnaldo
