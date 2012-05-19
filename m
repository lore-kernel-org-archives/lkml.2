Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab2ESOQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 10:16:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:21793 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab2ESOQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 10:16:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="145883452"
Date: Sat, 19 May 2012 22:13:30 +0800
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: <mingo@elte.hu>, <a.p.zijlstra@chello.nl>, <robert.richter@amd.com>,
        <ak@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] perf script/python: Pass thread/dso name and symbol
 info to event handler in python
Message-ID: <20120519221330.08b24ed1@feng-i7>
In-Reply-To: <20120518153854.GF2636@infradead.org>
References: <1337173155-25780-1-git-send-email-feng.tang@intel.com>
	<1337173155-25780-3-git-send-email-feng.tang@intel.com>
	<20120517154726.GC2636@infradead.org>
	<20120518105527.154fe294@feng-i7>
	<20120518153854.GF2636@infradead.org>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,


On Fri, 18 May 2012 12:38:54 -0300
Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Fri, May 18, 2012 at 10:55:27AM +0800, Feng Tang escreveu:
> > On Thu, 17 May 2012 12:47:26 -0300
> > Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> > > >  	PyTuple_SetItem(t, n++, PyString_FromStringAndSize(
> > > >  			data, sample->raw_size));
> > > > +	PyTuple_SetItem(t, n++, PyString_FromString(thread->comm));
> > > > +	PyTuple_SetItem(t, n++,
> > > > PyString_FromString(al->map->dso->name)); +
> > > > +	/* Pass the resolved symbol if there is, othersize pass
> > > > "Unkown" */
> > > > +	if (al->sym)
> > > > +		PyTuple_SetItem(t, n++,
> > > > PyString_FromString(al->sym->name));
> > > > +	else
> > > > +		PyTuple_SetItem(t, n++,
> > > > PyString_FromString("Unknown"));
> > > 
> > > Isn't this getting a little bit convoluted?
> > > 
> > > I.e. python has dictionaries, perhaps we could pass a dict instead of a
> > > tuple, in that case we would simply not add the "symbol" key.
> > 
> > IIRC, the PyObject_CallObjects() only accept "tuple" arguments, or did
> > you mean make the "symbol" a dict and an item of the "t" tuple?
> > 
> > I agree the symbol code is ugly, is following a little better?	
> > 	PyTuple_SetItem(t, n++, PyString_FromString((al->sym) ?
> > al->sym->name : "Unknown"));
> 
> What I meant was: make it so that the process_event() python method we
> look for receives as its first argument a dict.
> 
> I.e. pass a tuple to PyObject_CallObjects() that has just one entry: a
> dict.
> 
> This way if we need to add more parameters in the future, some of which
> may not exist (the "Unknown" ones). This way older scripts will continue
> working with newer perf tools, they just won't process the new stuff.

Got your point now. I've modified the code as you suggested and tested
them with my script which worked fine. Will send out a V2 for the whole
patch set after I got comments from David Ahern for my [PATCH 2/3]. Thanks,

- Feng

> 
> I.e. when adding features make sure that old scripts works with newer
> perf tools and vice versa as much as possible. If not possible, add
> notes to the relevant tools/perf/Documentation/ file.
> 
> - Arnaldo
