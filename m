Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab2CSVRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 17:17:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59295 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab2CSVRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 17:17:44 -0400
Date: Mon, 19 Mar 2012 18:17:33 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Colin Walters <walters@verbum.org>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL 0/3] perf/core fixes and improvements
Message-ID: <20120319211733.GA24118@infradead.org>
References: <1332184368-1655-1-git-send-email-acme@infradead.org>
 <20120319194725.GA31940@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319194725.GA31940@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 19, 2012 at 08:47:25PM +0100, Ingo Molnar escreveu:
> Pulled, thanks Arnaldo!
> 
> I noticed that there's no help text for GTK support - how will a 
> user find that 'perf report --gtk' will do something nice?
> 
> Another detail is that if GTK support is not compiled in:
> 
> Makefile:515: GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev
> 
> then the --gtk output is not very informative:
> 
>   earth5:~/tip/tools/perf> perf report --gtk
>   earth5:~/tip/tools/perf> 
> 
> :-)
> 
> A third detail, I do have gtk2-devel installed:
> 
>  Package gtk2-devel-2.24.10-1.fc17.x86_64 already installed and latest version

Yeah, as you said, the ball is rolling! ;-)

> yet I got the above message.
> 
> It is not easy to figure out *why* a feature test failed, 
> unfortunately. It would be nice if V=1 or something like that 
> would output the failure.

Yeah, I also was frustrated by V=1 not affecting the feature tests, and
did what you did, just didn't got around to fix it properly.
 
> I applied the hack below and ran the gtk testcase, which gave:
> 
> earth5:~/tip/tools/perf> . ./test.4273.sh
> In file included from /usr/lib64/glib-2.0/include/glibconfig.h:9:0,
>                  from /usr/include/glib-2.0/glib/gtypes.h:34,
>                  from /usr/include/glib-2.0/glib/galloca.h:34,
>                  from /usr/include/glib-2.0/glib.h:32,
>                  from /usr/include/glib-2.0/gobject/gbinding.h:30,
>                  from /usr/include/glib-2.0/glib-object.h:25,
>                  from /usr/include/glib-2.0/gio/gioenums.h:30,
>                  from /usr/include/glib-2.0/gio/giotypes.h:30,
>                  from /usr/include/glib-2.0/gio/gio.h:28,
>                  from /usr/include/gtk-2.0/gdk/gdkapplaunchcontext.h:30,
>                  from /usr/include/gtk-2.0/gdk/gdk.h:32,
>                  from /usr/include/gtk-2.0/gtk/gtk.h:32,
>                  from test.4273.c:2:
> /usr/include/glib-2.0/glib/gmacros.h:346:7: error: "_MSC_VER" is not defined [-Werror=undef]
> cc1: all warnings being treated as errors
> 
> Which allowed me to fix the feature test and the gtk.h include 
> file wrapper via the second patch below.
> 
> And then I was greeted by the GTK report window on 'perf report 
> --gtk' ;-)
> 
> Thanks,
> 
> 	Ingo
> 
> diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
> index 8046182..68cf795 100644
> --- a/tools/perf/config/utilities.mak
> +++ b/tools/perf/config/utilities.mak
> @@ -183,6 +183,8 @@ _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
>  # Usage: option = $(call try-cc, source-to-build, cc-options)
>  try-cc = $(shell sh -c						  \
>  	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
> +	 echo "$(1)" > test.$$$$.c;					  \
> +	 echo $(CC) -x c test.$$$$.c $(2) -o "$$TMP" > test.$$$$.sh;		  \
>  	 echo "$(1)" |						  \
>  	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
>  	 rm -f "$$TMP"')
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
> index d9084e0..ae8b471 100644
> --- a/tools/perf/config/feature-tests.mak
> +++ b/tools/perf/config/feature-tests.mak
> @@ -68,7 +68,9 @@ endif
>  ifndef NO_GTK2
>  define SOURCE_GTK2
>  #pragma GCC diagnostic ignored \"-Wstrict-prototypes\"
> +#pragma GCC diagnostic ignored \"-Wundef\"
>  #include <gtk/gtk.h>
> +#pragma GCC diagnostic error \"-Wundef\"
>  #pragma GCC diagnostic error \"-Wstrict-prototypes\"
>  
>  int main(int argc, char *argv[])
> diff --git a/tools/perf/util/gtk/gtk.h b/tools/perf/util/gtk/gtk.h
> index 75177ee..c7a941f 100644
> --- a/tools/perf/util/gtk/gtk.h
> +++ b/tools/perf/util/gtk/gtk.h
> @@ -2,7 +2,9 @@
>  #define _PERF_GTK_H_ 1
>  
>  #pragma GCC diagnostic ignored "-Wstrict-prototypes"
> +#pragma GCC diagnostic ignored "-Wundef"
>  #include <gtk/gtk.h>
> +#pragma GCC diagnostic error "-Wundef"
>  #pragma GCC diagnostic error "-Wstrict-prototypes"
>  
>  #endif /* _PERF_GTK_H_ */
