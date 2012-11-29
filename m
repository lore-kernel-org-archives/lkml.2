Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab2K2MU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 07:20:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab2K2MU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 07:20:58 -0500
Date: Thu, 29 Nov 2012 13:19:47 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 14/14] perf diff: Add generic order option for compute
 sorting
Message-ID: <20121129121947.GE1096@krava.brq.redhat.com>
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
 <1354110769-2998-15-git-send-email-jolsa@redhat.com>
 <87a9u0obwm.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9u0obwm.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 09:02:01PM +0900, Namhyung Kim wrote:
> On Wed, 28 Nov 2012 14:52:49 +0100, Jiri Olsa wrote:
> > Adding option 'o' to allow sorting based on the
> > input file number.
> [snip]
> >  hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
> >  			int c)
> >  {
> > -	int i;
> > +	struct hist_entry **pairs_left  = left->pairs;
> > +	struct hist_entry **pairs_right = right->pairs;
> > +	struct hist_entry *p_right, *p_left;
> > +	static int64_t cmp;
> >  
> > -	for (i = 0; i < data_cnt; i++) {
> > -		struct hist_entry **pairs_left  = left->pairs;
> > -		struct hist_entry **pairs_right = right->pairs;
> > -		struct hist_entry *p_right, *p_left;
> > -		static int64_t cmp;
> > +	if (!pairs_left || !pairs_right)
> > +		return pairs_left ? -1 : 1;
> >  
> > -		if (!pairs_left || !pairs_right)
> > -			return pairs_right - pairs_left;
> > +	p_right = pairs_right[sort_compute];
> > +	p_left  = pairs_left[sort_compute];
> >  
> > -		p_right = pairs_right[i];
> > -		p_left  = pairs_left[i];
> > +	if (!p_left || !p_right)
> > +		return p_left ? -1 : 1;
> 
> What if both p_left and p_right are NULL?  Shouldn't it be move to the
> next pairs?
hm, right.. we bail out, but not sure what to return.. 0,-1 or 1


> 
> >  
> > -		if (!p_left || !p_right)
> > -			return p_right - p_left;
> > -
> > -		/*
> > -		 * If we differ, we are done, otherwise continue until all
> > -		 * is processed or we find a difference.
> > -		 */
> > -		cmp = __hist_entry__cmp_compute(p_left, p_right, c);
> > -		if (cmp)
> > -			return cmp;
> > -	}
> > +	/*
> > +	 * If we differ, we are done, otherwise continue until all
> > +	 * is processed or we find a difference.
> > +	 */
> 
> I guess this comment is not applied anymore.  Or we need a loop after
> checking sort_compute column, right?

unfortunatelly formated.. if we get this far, we have numbers to compare..
meaning: we have 2 lines that have same, non empty column to compare

thanks,
jirka
