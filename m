Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab3AIQ4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:56:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932251Ab3AIQ4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:56:01 -0500
Date: Wed, 9 Jan 2013 17:55:39 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v5 11/18] perf tools: add mem access sampling core support
Message-ID: <20130109165539.GB1045@krava.brq.redhat.com>
References: <1357583277-4553-1-git-send-email-eranian@google.com>
 <1357583277-4553-12-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357583277-4553-12-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 07:27:50PM +0100, Stephane Eranian wrote:

SNIP

>  
> +static void ip__resolve_data(struct machine *self, struct thread *thread,
> +			     u8 m,
> +			    struct addr_map_symbol *ams,
> +			    u64 addr)
> +{
> +	struct addr_location al;
> +
> +	memset(&al, 0, sizeof(al));
> +
> +	thread__find_addr_location(thread, self, m, MAP__VARIABLE, addr, &al,
> +				   NULL);
> +	ams->addr = addr;
> +	ams->al_addr = al.addr;
> +	ams->sym = al.sym;
> +	ams->map = al.map;
> +}
> +
> +struct mem_info *machine__resolve_mem(struct machine *self,
> +				      struct thread *thr,
> +				      struct perf_sample *sample,
> +				      u8 cpumode)
> +{
> +	struct mem_info *mi;
> +
> +	mi = calloc(1, sizeof(struct mem_info));
> +	if (!mi)
> +		return NULL;
> +
> +	ip__resolve_ams(self, thr, &mi->iaddr, sample->ip);
> +	ip__resolve_data(self, thr, cpumode, &mi->daddr, sample->addr);
> +	mi->cost = sample->weight;
> +	mi->dsrc.val = sample->dsrc;
> +
> +	return mi;
> +}
> +

The crash I report is due to the some maps could be removed
via map_groups__fixup_overlappings.

Attached patch makes the code working for me, but we might
want to have some global unified fix for that, since this
is not the only place suffering for that.

Like globaly set map->referenced in add_hist_entry or
hist_entry__new functions..


jirka
---
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 49ca66b..615aecf 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -266,11 +266,15 @@ static void ip__resolve_ams(struct machine *self, struct thread *thread,
 		if (al.sym)
 			goto found;
 	}
+
 found:
 	ams->addr = ip;
 	ams->al_addr = al.addr;
 	ams->sym = al.sym;
 	ams->map = al.map;
+
+	if (ams->map)
+		ams->map->referenced = true;
 }
 
 static void ip__resolve_data(struct machine *self, struct thread *thread,
@@ -288,6 +292,9 @@ static void ip__resolve_data(struct machine *self, struct thread *thread,
 	ams->al_addr = al.addr;
 	ams->sym = al.sym;
 	ams->map = al.map;
+
+	if (ams->map)
+		ams->map->referenced = true;
 }
 
 struct mem_info *machine__resolve_mem(struct machine *self,
