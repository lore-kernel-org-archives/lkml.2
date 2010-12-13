Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669Ab0LMSKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 13:10:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:35939 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553Ab0LMSKx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 13:10:53 -0500
Subject: Re: [PATCH 1/2] perf tools: Add reference timestamp to perf header
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Ahern" <daahern@cisco.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20101213180548.GF1691@nowhere>
References: <20101213155451.GA1691@nowhere>
	 <20101213164854.GL5407@ghostprotocols.net> <20101213170923.GB1691@nowhere>
	 <1292260289.6803.297.camel@twins> <20101213171537.GC1691@nowhere>
	 <1292260699.6803.305.camel@twins>
	 <20101213172216.GB7417@ghostprotocols.net>
	 <1292261716.6803.332.camel@twins>
	 <20101213174330.GC7417@ghostprotocols.net>
	 <1292262673.6803.359.camel@twins>  <20101213180548.GF1691@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Dec 2010 19:10:24 +0100
Message-ID: <1292263824.6803.391.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 19:05 +0100, Frederic Weisbecker wrote:
> 
> There is one writer per cpu and a (stupid) multiplexing at report time.
> It was working. Just the sorting on report time was (stupidly) slow.
> 
> I should perhaps rebase that branch and try to make something with it. 

Right, so we need to have a small ~16 events sort window per file [*],
and then a merge-sort over all files, simply consumer the most recent
event across all files.

We can have out-of-order events on a single cpu due to nesting and
taking the time-stamp _before_ we reserve the buffer. We could cure some
of this by moving the perf_clock() call from
__perf_event_header__init_id()/perf_prepare_sample() to
__perf_event_output_id_sample()/perf_output_sample().

