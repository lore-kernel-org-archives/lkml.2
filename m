Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab2ERPjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:39:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906Ab2ERPjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:39:11 -0400
Date: Fri, 18 May 2012 12:38:54 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Feng Tang <feng.tang@intel.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, robert.richter@amd.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] perf script/python: Pass thread/dso name and symbol
 info to event handler in python
Message-ID: <20120518153854.GF2636@infradead.org>
References: <1337173155-25780-1-git-send-email-feng.tang@intel.com>
 <1337173155-25780-3-git-send-email-feng.tang@intel.com>
 <20120517154726.GC2636@infradead.org>
 <20120518105527.154fe294@feng-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518105527.154fe294@feng-i7>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 18, 2012 at 10:55:27AM +0800, Feng Tang escreveu:
> On Thu, 17 May 2012 12:47:26 -0300
> Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> > >  	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
> > >  			data, sample->raw_size));
> > > +	PyTuple_SetItem(t, n++, PyString_FromString(thread->comm));
> > > +	PyTuple_SetItem(t, n++, PyString_FromString(al->map->dso->name));
> > > +
> > > +	/* Pass the resolved symbol if there is, othersize pass "Unkown" */
> > > +	if (al->sym)
> > > +		PyTuple_SetItem(t, n++,
> > > PyString_FromString(al->sym->name));
> > > +	else
> > > +		PyTuple_SetItem(t, n++, PyString_FromString("Unknown"));
> > 
> > Isn't this getting a little bit convoluted?
> > 
> > I.e. python has dictionaries, perhaps we could pass a dict instead of a
> > tuple, in that case we would simply not add the "symbol" key.
> 
> IIRC, the PyObject_CallObjects() only accept "tuple" arguments, or did
> you mean make the "symbol" a dict and an item of the "t" tuple?
> 
> I agree the symbol code is ugly, is following a little better?	
> 	PyTuple_SetItem(t, n++, PyString_FromString((al->sym) ? al->sym->name : "Unknown"));

What I meant was: make it so that the process_event() python method we
look for receives as its first argument a dict.

I.e. pass a tuple to PyObject_CallObjects() that has just one entry: a
dict.

This way if we need to add more parameters in the future, some of which
may not exist (the "Unknown" ones). This way older scripts will continue
working with newer perf tools, they just won't process the new stuff.

I.e. when adding features make sure that old scripts works with newer
perf tools and vice versa as much as possible. If not possible, add
notes to the relevant tools/perf/Documentation/ file.

- Arnaldo
