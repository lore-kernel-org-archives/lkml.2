Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab1FHTAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:00:45 -0400
Received: from mta11.charter.net ([216.33.127.80]:50077 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab1FHTAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:00:44 -0400
X-Authority-Analysis: v=1.1 cv=1b2X7W/SifksZeClH/haT1SUt4udqxFGF00pZw2/jJk=
 c=1 sm=1 a=p9YancsnzTcA:10 a=bwGQv-0rnx0A:10 a=8nJEP1OIZ-IA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=ViISwhkDyBNPKYQtUP0A:9 a=wPNLvfGTeEIA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4DEFC6DA.9050809@cuw.edu>
Date: Wed, 08 Jun 2011 14:00:42 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
CC: julia@diku.dk, rdunlap@xenotime.net, Gilles.Muller@lip6.fr,
        npalix.work@gmail.com, cocci@diku.dk, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] coccicheck: add M= option to control which dir is
 processed
References: <1307503774-30370-1-git-send-email-Gregory.Dietsche@cuw.edu> <1307503774-30370-2-git-send-email-Gregory.Dietsche@cuw.edu>
In-Reply-To: <1307503774-30370-2-git-send-email-Gregory.Dietsche@cuw.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/07/2011 10:29 PM, Greg Dietsche wrote:
> Examples:
> 	make coccicheck M=drivers/net/wireless/
> 	make coccicheck SUBDIRS=drivers/net/wireless/
>
> Signed-off-by: Greg Dietsche<Gregory.Dietsche@cuw.edu>
> ---
>   scripts/coccicheck |   13 +++++++++++--
>   1 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/scripts/coccicheck b/scripts/coccicheck
> index 1bb1a1b..6f08efa 100755
> --- a/scripts/coccicheck
> +++ b/scripts/coccicheck
> @@ -10,13 +10,22 @@ if [ "$C" = "1" -o "$C" = "2" ]; then
>   #    OPTIONS=$*
>
>   # Workaround for Coccinelle<  0.2.3
> -    FLAGS="-I $srctree/include -very_quiet"
> +    if [ "$KBUILD_EXTMOD" = "" ] ; then
> +        FLAGS="-I $srctree/include -very_quiet"
> +    else
> +	    echo 'M= is only supported for Coccinelle>= 0.2.3'
> +	    exit 1
> +    fi
>       shift $(( $# - 1 ))
>       OPTIONS=$1
>   else
>       ONLINE=0
>       FLAGS="-very_quiet"
> -    OPTIONS="-dir $srctree"
> +    if [ "$KBUILD_EXTMOD" = "" ] ; then
> +        OPTIONS="-dir $srctree"
> +    else
> +        OPTIONS="-dir $KBUILD_EXTMOD"
>    
So far I've found one bug after reading Nicolas's comments on the other 
thread. In order to have the diffs print file names correctly, I 
definitely need to update my patch to do this:

+        OPTIONS="-dir $KBUILD_EXTMOD -patch $srctree"

Also, do I need to tell cocci where the includes are? Based on my somewhat limited knowledge and testing, I'm not sure... but so far the tests seem to work without it. If we really do need to tell it about the includes, then the line should read:

+        OPTIONS="-dir $KBUILD_EXTMOD -patch $srctree -I $srctree/include"



> +    fi
>   fi
>
>   if [ ! -x "$SPATCH" ]; then
>    

Greg

