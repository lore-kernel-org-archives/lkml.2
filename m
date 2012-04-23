Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab2DWVXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:23:50 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:59501 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab2DWVXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:23:48 -0400
Date: Mon, 23 Apr 2012 14:23:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: Incomplete cherry-pick on linux-3.3.y branch
Message-ID: <20120423212344.GB3378@kroah.com>
References: <CAMe9rOqy4g9QeOC7xWRmi3Wr=97qbUXm1G69pWgdcfykJQgMPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMe9rOqy4g9QeOC7xWRmi3Wr=97qbUXm1G69pWgdcfykJQgMPQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 23, 2012 at 12:08:13PM -0700, H.J. Lu wrote:
> Hi,
> 
> This cherry-pick commit:
> 
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commit;h=1cb41fe7e34a43a1d27dfdb6d65699786dd44c20
> 
> doesn't work on 3.3 branch since it misses other commits
> required.  On 3.3 branch, there are
> 
> struct hist_entry *__hists__add_entry(struct hists *hists,
>                                       struct addr_location *al,
>                                       struct symbol *sym_parent, u64 period)
> {
>         struct rb_node **p;
>         struct rb_node *parent = NULL;
>         struct hist_entry *he;
>         struct hist_entry entry = {
>                 .thread = al->thread,
> 
> It doesn't work with
> 
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index e11e482..a47a6f1 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -230,6 +230,18 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
>  		if (!cmp) {
>  			he->period += period;
>  			++he->nr_events;
> +
> +			/* If the map of an existing hist_entry has
> +			 * become out-of-date due to an exec() or
> +			 * similar, update it.  Otherwise we will
> +			 * mis-adjust symbol addresses when computing
> +			 * the history counter to increment.
> +			 */
> +			if (he->ms.map != entry->ms.map) {
> +				he->ms.map = entry->ms.map;
> +				if (he->ms.map)
> +					he->ms.map->referenced = true;
> +			}
>  			goto out;
>  		}
> 
> since entry isn't a pointer on 3.3 branch.

Already fixed in the stable-queue tree, and will show up in the next
kernel release.  If you need a fix now, use the one below.

thanks,

greg k-h

--gKMricLos+KVdGMg
Content-Type: text/x-patch; charset=utf-8
Content-Disposition: attachment; filename="perf-fix-build-breakage.patch"
Content-Transfer-Encoding: 8bit

>From zeev.tarantov@gmail.com Sun Apr 22 23:38:36 2012
From: Zeev Tarantov <zeev.tarantov@gmail.com>
Date: Mon, 23 Apr 2012 09:37:04 +0300
Subject: Perf: fix build breakage
To: "David S. Miller" <davem@davemloft.net>, Arnaldo Carvalho de Melo <acme@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20120423063704.GA3465@myhost>
Content-Disposition: inline


From: Zeev Tarantov <zeev.tarantov@gmail.com>

[Patch not needed upstream as this is a backport build bugfix - gregkh

gcc correctly complains:

util/hist.c: In function ‘__hists__add_entry’:
util/hist.c:240:27: error: invalid type argument of ‘->’ (have ‘struct hist_entry’)
util/hist.c:241:23: error: invalid type argument of ‘->’ (have ‘struct hist_entry’)

for this new code:

+                       if (he->ms.map != entry->ms.map) {
+                               he->ms.map = entry->ms.map;
+                               if (he->ms.map)
+                                       he->ms.map->referenced = true;
+                       }

because "entry" is a "struct hist_entry", not a pointer to a struct.

In mainline, "entry" is a pointer to struct passed as argument to the function.
So this is broken during backporting. But obviously not compile tested.

Signed-off-by: Zeev Tarantov <zeev.tarantov@gmail.com>
Cc: Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/hist.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -237,8 +237,8 @@ struct hist_entry *__hists__add_entry(st
 			 * mis-adjust symbol addresses when computing
 			 * the history counter to increment.
 			 */
-			if (he->ms.map != entry->ms.map) {
-				he->ms.map = entry->ms.map;
+			if (he->ms.map != entry.ms.map) {
+				he->ms.map = entry.ms.map;
 				if (he->ms.map)
 					he->ms.map->referenced = true;
 			}

--gKMricLos+KVdGMg--
