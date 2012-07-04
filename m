Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab2GDK3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 06:29:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:39330 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024Ab2GDK3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 06:29:19 -0400
Subject: Re: [PATCH 04/10] perf, x86: Making hardware events translations
 available in sysfs
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1341397494.2507.88.camel@laptop>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
	 <1341352848-11833-5-git-send-email-jolsa@redhat.com>
	 <1341397494.2507.88.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 12:28:58 +0200
Message-ID: <1341397738.2507.92.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 12:24 +0200, Peter Zijlstra wrote:
> On Wed, 2012-07-04 at 00:00 +0200, Jiri Olsa wrote:
> > +static struct attribute *events_attr[] = {
> > +       &event_attr_cycles.attr,
> > +       &event_attr_instructions.attr,
> > +       &event_attr_cache_references.attr,
> > +       &event_attr_cache_misses.attr,
> > +       &event_attr_branch_instructions.attr,
> > +       &event_attr_branch_misses.attr,
> > +       &event_attr_bus_cycles.attr,
> > +       &event_attr_stalled_cycles_frontend.attr,
> > +       &event_attr_stalled_cycles_backend.attr,
> > +       &event_attr_ref_cycles.attr,
> > +       NULL,
> > +}; 
> 
> Hmm, should we do:
> 
>   if (!config)
>     return -EINVAL;
> 
> or somesuch to clearly indicate an event isn't supported?
> 
> Its currently a bit of a mixed bag between 0 and -1.. we might want to
> clean that up too.

Alternatively, we'd do something like:

  for (i = 0; events_attr[i]; i++) {
    if (x86_pmu.event_map(i))
      continue;

    for (j = i; events_attr[j]; j++)
      events_attr[j] = events_attr[j+1];
  }

On init to filter out all unset events so they don't even show up in
sysfs.
      

