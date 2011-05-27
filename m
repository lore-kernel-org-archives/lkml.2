Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab1E0XbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 19:31:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42042 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414Ab1E0XbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 19:31:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=GgGHVRAJ4I2cXJRAS7lxy7XwHEn6TLO6oX/w1kuP+9QvnWhhrQJpU4AXECTuLPLWjc
         2miyMEjV48egzUuWeJag==
Date: Fri, 27 May 2011 16:30:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Jack Steiner <steiner@sgi.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Paul Menage <menage@google.com>,
        Robin Holt <holt@sgi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2] cpusets: randomize node rotor used in
 cpuset_mem_spread_node()
In-Reply-To: <20110527231700.GA3214@tiehlicka.suse.cz>
Message-ID: <alpine.DEB.2.00.1105271628430.9445@chino.kir.corp.google.com>
References: <20110414065146.GA19685@tiehlicka.suse.cz> <20110414160145.0830.A69D9226@jp.fujitsu.com> <20110415161831.12F8.A69D9226@jp.fujitsu.com> <20110415082051.GB8828@tiehlicka.suse.cz> <20110526153319.b7e8c0b6.akpm@linux-foundation.org>
 <20110527124705.GB4067@tiehlicka.suse.cz> <20110527142051.d7ec3784.akpm@linux-foundation.org> <20110527231700.GA3214@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 May 2011, Michal Hocko wrote:

> > --- a/include/linux/nodemask.h~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2
> > +++ a/include/linux/nodemask.h
> > @@ -433,8 +433,6 @@ static inline void node_set_offline(int 
> >  	nr_online_nodes = num_node_state(N_ONLINE);
> >  }
> >  
> > -extern int node_random(const nodemask_t *maskp);
> > -
> >  #else
> >  
> >  static inline int node_state(int node, enum node_states state)
> > @@ -466,7 +464,15 @@ static inline int num_node_state(enum no
> >  #define node_set_online(node)	   node_set_state((node), N_ONLINE)
> >  #define node_set_offline(node)	   node_clear_state((node), N_ONLINE)
> >  
> > -static inline int node_random(const nodemask_t *mask) { return 0; }
> > +#endif
> > +
> > +#if defined(CONFIG_NUMA) && (MAX_NUMNODES > 1)
> > +extern int node_random(const nodemask_t *maskp);
> > +#else
> > +static inline int node_random(const nodemask_t *mask)
> > +{
> > +	return 0;
> > +}
> >  #endif
> 
> I have to admit that I quite don't understand concept of several nodes
> with UMA archs but do we really want to provide the sane node all the
> time?
> 

They aren't nodes on UMA machines, they are memory regions for 
DISCONTIGMEM which are separated by large holes in the address space.  
These archs will never sanely use node_random(), so it doesn't really 
matter except for CONFIG_NUMA where MAX_NUMNODES > 1, since they won't be 
selecting random memory regions.
