Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab0DAIIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 04:08:47 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:43282 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136Ab0DAIIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 04:08:39 -0400
Date: Thu, 1 Apr 2010 10:11:26 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Henrik Kretzschmar <henne@nachtwindheim.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: section cleanup
Message-ID: <20100401081126.GC23247@secunet.com>
References: <1269672826-1102-1-git-send-email-henne@nachtwindheim.de>
 <20100329081550.GA22334@gondor.apana.org.au>
 <20100331145817.bd0a1a08.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331145817.bd0a1a08.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 01 Apr 2010 08:08:37.0002 (UTC) FILETIME=[87E6FEA0:01CAD172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 02:58:17PM -0700, Andrew Morton wrote:
> 
> What is it for, how does it work, where might it otherwise be used,
> what are the dynamics, why does it use softirqs rather than (say)
> kernel threads and how do we stop it from using yield()?
> 

padata can be used to spread cpu intensive work over multiple cpus. It came
into being with the idea to parallelize IPsec. We separated the generic
parts out to padata in the hope it can be useful to others too.
So padata is used to parallelize cpu intensive codepaths, like crypto
operations. As soon as the cpu intensive work is done, it is possible to
serialize again without getting reorder of the parallelized objects.
This is in particular important for IPsec to keep the network packets
in the right order.

To achieve a parallelization of the cpu intensive parts of IPsec, we
created the pcrypt parallel crypto template (crypto/pcrypt.c). This
wraps around an existing crypto algorithm and does the
parallelization/serialization by using padata. So pcrypt is an example on
how to use padata.

I'm about to write some documentation for padata/pcrypt. The big picture
is as follows. A user can allocate a padata instance by using padata_alloc().
The user can specify the cpumask of the cpus and the workqueue he wants to
use for the parallel codepath on allocation time. After allocation it is
possible to start/stop the padata instance with padata_start() padata_stop().
The actual parallel codepath is entered by calling padata_do_parallel().
The parallelized objects, in case of pcrypt the crypto requests, need to
embed padata's control structure of type struct padata_priv. This structure
is the anchor for padata to handle the object. padata_do_parallel() takes
three parameters, the padata instance on which to parallelize, the control
structure that is embedded in the object and a callback cpu on which the
object will appear after serialization. Once the cpu intensive work is done,
it is possible to serialize by calling padata_do_serial(). This function
takes the padata control structure as parameter. It brings the parallelized
objects back to the order they were before the parallelization and sends
them to the cpu which was specified as the callback cpu.

Internally padata uses a workqueue to do the parallelization/serialization,
not softirqs (some earlier versions used softirqs).

I was not aware that using yield() is considered to be a bad thing, it is
of course possible to do it without yield() if this is wanted.

Steffen
