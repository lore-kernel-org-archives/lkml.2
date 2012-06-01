Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab2FAChM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 22:37:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64900 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758413Ab2FAChI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 22:37:08 -0400
Date: Fri, 1 Jun 2012 11:37:00 +0900
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 14/16] bcache: Request, io and allocation code
Message-ID: <20120601023700.GE32121@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <9ea33658f2a71b3b9bd2ec10bee959bef146f23c.1336619038.git.koverstreet@google.com>
 <20120530072358.GB4854@google.com>
 <20120531005224.GA5645@google.com>
 <20120531024327.GC32121@google.com>
 <20120531051321.GA12602@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120531064515.GA18984@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120531064515.GA18984@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again, Kent.

On Thu, May 31, 2012 at 03:45:15PM +0900, Tejun Heo wrote:
> I still don't understand what's being made better by closure.  At
> least the ones I've seen didn't seem to be justified, so if you have
> some examples which highlight the benefits of closure, please go ahead
> and explain them.
> 
> I'll write more about it later but here are some of my current
> thoughts.

I'm gonna try my (personal, of course) reasoning on closure.  It's
gonna be long-winded and fairly abstract.  The issue at hand is an
abstract one and I don't know how to communicate it better.  :(

My objection to closure is largely two-fold.

1. Excessive abstraction / mosaicing of functions.

Abstraction itself isn't a goal onto itself - it is a (pretty
important) tool that we rely on to manage complexities.  By the very
nature, it's heavily dependent on what concepts one develops on the
subjct and those concepts may grow substantially removed from the
concrete requirements and functionality, and as they get further
removed from the concrete, different people tend to arrive at
conclusions vastly far apart.  One man's paradise can easily be
another's hell.  Concepts clear to one mind can be completely
ambiguous or disturbing to others.

It's a problem with no fast solution but IMHO trying to minimize the
distance between the needed functionality (requirements) and the
abstraction.  You brought up RB tree earlier in the discussion and
that's a great example.  It provides a clear functionality of balanced
search tree without much extra abstracting.  Most software developers
can agree on the need of searching an element based on a key value and
RB tree implements that specific functionality.  If one understands
the need, the abstraction is fundamental and immediate and thus
self-evident.

One effective way of reaching at a bad abstraction, I think, is overly
generalizing limited local usage patterns.  When one sees certain
pattern repeated, it's tempting to overly generalize and make it some
fundamental abstraction when the only things which actually exist are
local usage patterns.

Such over-generalization often ends up bundling things which aren't
fundamentally associated.  After all, there aren't clear fundamental
requirements such an abstraction is serving - it is a mosaic of
incidental set of features which happen to be in use for the specific
part of code.  Generalized ambiguity can be very generous - combining
A and B resulted in this awesome generic super construct, adding C on
top would woule make it super-duper, right?

This harms both the local usage and the code base in general.  Local
code develops unnecessary (generic things tend to have lives of their
own) distance between the actual requirements and the mechanism
implementing them making it more difficult to understand, and the rest
of code base gets something which seems generic but is ambiguos,
difficult to understand and easy to misuse.

I personally think kobject is a good example of this.  Its name seems
to suggest it's something like the base type for kernel objects.
Pretty ambiguous and ambitious.  If you look at it, it's a combination
of refcnting, elements for sysfs representation, weird looking type
system mostly born out from sysfs usage and device driver model,
userland notification mechanism and some more.  It's ass-ugly but
seems to fit device driver model okish.  Unfortunately, as soon as it
gets dragged out of device driver model, it isn't clear what different
parts of the dang thing are supposed to do.

For some device-driver-model specific reason, a directory in sysfs
hierarchy maps to a kobject (there are attr dirs which are exceptions
tho).  As soon as you start using sysfs outside device driver model,
it becomes weird.  An entity which wants to expose something via sysfs
somehow has to use kobject which brings in its object lifetime
management which may not fit the existing usage model.

Let's say there are entities A, B and C, where A and B follow mostly
the same life-cycle rules and C is dependent on B, and A and C have
something to expose via sysfs.  So, A and C embed kobjects inside
them.  What about kobj life-cycle management then?  Let's say A and C
use kobj life-cycle management.  Hmmm... C is dependent on B.  How
does that play out?  What if some in-kernel entity represents two
separate userland-visible entities?  What happens then?  Do people
have to suppress / circumvent kobj lifecycle mechanism?  Wouldn't that
make the code unnecessarily difficult to understand - extra cruft
tends to be very effective at confusing people?

The stupid thing is that sysfs doesn't need any of the kobject
silliness.  sysfs should have provided interface fundamental to its
features which device driver model should have used to implement
whatever specific abstraction necessary and keep that inside.  The
association between certain type of life cycle management and sysfs
usage wasn't anything fundamental.  It was a device driver model local
thing and the mechanism too should have stayed local inside the device
driver model.

At least for me, closure triggers all the alarms for bad generic
abstraction.  The patch description you wrote for closure starts with
"asynchronous refcounty thingies" and it's quite apt.  It's a
combination of object life-cycle management, async execution, object
hierarchy, event mechanism and even locking.  It isn't anything
fundamental.  It's a kitchen sink with spoon, knife, chainsaw and
toilet welded together.


2. Making async programming better, or glaze-coating turd.

As I wrote before, I personally think that async programming - using
something other than stack for execution state - is inherently
inferior.  The programming languages we program in and the processors
the resulting programs run on depend on stack for execution context
after all.  To my mind, async programming is inherently a turd.

That isn't to say we can do away with async programming completely.
At times, turds are unavoidable and even essential (and the line
between turds and !turds isn't clear to begin with).  Process context
can be expensive in terms of switching and/or memory overhead.  It
would be silly to keep ten thousand threads lying around listening to
ten thousand idle clients which may or may not make another request.
It could also be silly to switch to a process context just to relay
completion notification to another process context (although block
layer kinda does that for a different reason).

In block layer, the need for async programming rises mostly from the
disconnection between issue and completion contexts.  The issuing
context may not wait for the completion and we end up with IOs without
matching process contexts.  The problem isn't too bad tho.  We require
and thus have process context on the issue path and the completion
paths tend to be not too complex.

When we have to deal with async programming, I think the best approach
is to identify why they're necessary, restrict their scopes to minimum
and clearly contain them.  For example, bounce to wq as soon as things
start to get complex, don't try to be smart with process contexts
while something complex is going on, and relinquish context judicially
when not doing so results in noticeable performance / resource hit and
hopefully where doing so doesn't complicate things too much (e.g. it's
a clear retry boundary).

If you follow such patterns, there isn't too much need for fancy async
mechanism to blur the pain.  Properly identified and consolidated,
sync / async boundaries shouldn't be too painful to manage and the
kernel already provides ample mechanisms to support such patterns.

The problem with closure is that it's a mechanism to glaze-coat turd.
By glaze-coating, it encourages littering turds around instead of
consolidating and isolating them, so in that sense, I prefer async
programming to remain painful and explicit.  People tend to do
bat-shit crazy stuff otherwise.


To conclude, I *hope* that bcache followed more usual async
programming conventions, much like I hope it followed more usual
coding style.  These aren't cut-and-dry issues and there probably are
aspects that I haven't considered or lost balance on.  Please feel
free to point them out.

Thanks.

-- 
tejun
