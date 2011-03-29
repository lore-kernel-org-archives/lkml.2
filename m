Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1C2SPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 14:15:35 -0400
Received: from wnohang.net ([178.79.154.173]:47737 "EHLO mail.wnohang.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030Ab1C2SPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 14:15:34 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 14DD924A0F
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net C880724906
Date: Tue, 29 Mar 2011 23:45:24 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
To: Michael Witten <mfwitten@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use the environment variable PYTHON if defined
Message-ID: <20110329181524.GA5140@Xye>
References: <20110326224408.GA1336@Xye>
 <20110328144721.GB17872@ghostprotocols.net>
 <e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com>
X-Operating-System: Arch linux x86_64 2.6.38.2-bldit-db-FAE
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* On Mon, Mar 28, 2011 at 10:36:02PM +0000, Michael Witten <mfwitten@gmail.=
com> wrote:
>On Sat, Mar 26, 2011 at 17:44, Raghavendra D Prabhu <rprabhu@wnohang.net> =
wrote:
>> On systems with python{2,3} installed, perf build can break
>> which can be fixed by exporting PYTHON to the right value.
>> Added support for PYTHON in the Makefile.
>
>Yes, I too have run into this problem; my distribution, Arch Linux,
>installs python3 as the main python:
>
>  /usr/bin/python{,-config}
>
>and python2 as an ancillary, versioned python:
>
>  /usr/bin/python2{,-config}
>
>The real problem here is not so much that perf's Makefile
>hardcodes the program names `python' and `python-config';
>rather, the problem is that perf's python code (both .c
>and probably .py) is incompatible with python3, thereby
>causing the build to break.
>
>The Correct Solution (for the most part) is to make perf's
>python code compatible with both versions of python
>(I was hoping somebody who knows these things better would
>do it, which is why I never submitted a patch for
>changing the hardcoded values).
>
>In any case, Raghavendra's patch is a pretty darn good
>bandage that will allow people to keep working; however,
>$(PYTHON) can be used in a few other places, and the
>assignment of its value can be error-checked more thoroughly.
>
>The following is a patch that does a bit more; you can save
>this email to `path/to/email' and then apply the patch
>by running:
>
>  git am --scissors path/to/email
>
>8<--------8<--------8<--------8<--------8<--------8<--------8<
>Subject: [PATCH] perf tools: Makefile: PYTHON{,_CONFIG} to bandage python3=
 incompatibility
>Currently, python3 is not supported by perf's code; this
>can cause the build to fail for systems that have python3
>installed as the default python:
>
>  python{,-config}
>
>The Correct Solution is to write compatibility code so that
>python3 works out-of-the-box.
>
>However, users often have an ancillary python2 installed:
>
>  python2{,-config}
>
>Therefore, a quick fix is to allow the user to specify those
>ancillary paths as the python binaries that Makefile should
>use, thereby avoiding python3 altogether.
>
>This commit adds the ability to set PYTHON and/or PYTHON_CONFIG
>either as environment variables or as make variables on the
>command line; the paths may be relative, and usually only
>PYTHON is necessary in order for PYTHON_CONFIG to be defined
>implicitly.
>
>Thanks to:
>
>  Raghavendra D Prabhu <rprabhu@wnohang.net>
>
>for motivating this patch.
>
>See:
>
>  Message-ID: <e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com>
>
>Signed-off-by: Michael Witten <mfwitten@gmail.com>
>---
> tools/perf/Makefile          |   22 +++++++++++++++++---
> tools/perf/feature-tests.mak |   44 +++++++++++++++++++++++++++++++++++++=
+++++
> 2 files changed, 62 insertions(+), 4 deletions(-)
>
>diff --git a/tools/perf/Makefile b/tools/perf/Makefile
>index 158c30e..b468383 100644
>--- a/tools/perf/Makefile
>+++ b/tools/perf/Makefile
>@@ -13,6 +13,12 @@ endif
>
> # Define V to have a more verbose compile.

>+# Define PYTHON to point to the python binary if the default
>+# `python' is not correct; for example: PYTHON=3Dpython2
>+#
>+# Define PYTHON_CONFIG to point to the python-config binary if
>+# the default `$(PYTHON)-config' is not correct.
>+#
> # Define ASCIIDOC8 if you want to format documentation with AsciiDoc 8

> # Define DOCBOOK_XSL_172 if you want to format man pages with DocBook XSL=
 v1.72.
>@@ -165,7 +171,7 @@ grep-libs =3D $(filter -l%,$(1))
> strip-libs =3D $(filter-out -l%,$(1))
>
> $(OUTPUT)python/perf.so: $(PYRF_OBJS)
>-	$(QUIET_GEN)python util/setup.py --quiet  build_ext --build-lib=3D'$(OUT=
PUT)python' \
>+	$(QUIET_GEN)$(PYTHON) util/setup.py --quiet  build_ext --build-lib=3D'$(=
OUTPUT)python' \
> 						--build-temp=3D'$(OUTPUT)python/temp'

> # No Perl scripts right now:
>@@ -474,10 +480,18 @@ endif
> ifdef NO_LIBPYTHON
> 	BASIC_CFLAGS +=3D -DNO_LIBPYTHON
> else
>+        override PYTHON :=3D \
>+            $(or $(call get-supplied-or-default-executable,$(PYTHON),pyth=
on),\
>+                 $(error Please set PYTHON appropriately))
>+
>+        override PYTHON_CONFIG :=3D \
>+            $(or $(call get-supplied-or-default-executable,$(PYTHON_CONFI=
G),$(PYTHON)-config),\
>+                 $(error Please set PYTHON_CONFIG appropriately))
>+
>-       PYTHON_EMBED_LDOPTS =3D $(shell python-config --ldflags 2>/dev/nul=
l)
>+       PYTHON_EMBED_LDOPTS =3D $(shell $(PYTHON_CONFIG) --ldflags 2>/dev/=
null)
>        PYTHON_EMBED_LDFLAGS =3D $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
>        PYTHON_EMBED_LIBADD =3D $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
>-	PYTHON_EMBED_CCOPTS =3D `python-config --cflags 2>/dev/null`
>+	PYTHON_EMBED_CCOPTS =3D $(shell $(PYTHON_CONFIG) --cflags 2>/dev/null)
> 	FLAGS_PYTHON_EMBED=3D$(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
> 	ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
> 		msg :=3D $(warning No Python.h found, install python-dev[el] to have py=
thon support in 'perf script' and to build the python bindings)
>@@ -829,7 +843,7 @@ clean:
> 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tag=
s cscope*
> 	$(MAKE) -C Documentation/ clean
> 	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
>-	@python util/setup.py clean --build-lib=3D'$(OUTPUT)python' \
>+	@$(PYTHON) util/setup.py clean --build-lib=3D'$(OUTPUT)python' \
> 				   --build-temp=3D'$(OUTPUT)python/temp'
>
> .PHONY: all install clean strip
>diff --git a/tools/perf/feature-tests.mak b/tools/perf/feature-tests.mak
>index b041ca6..8d677f4 100644
>--- a/tools/perf/feature-tests.mak
>+++ b/tools/perf/feature-tests.mak
>@@ -128,3 +128,47 @@ try-cc =3D $(shell sh -c						  \
> 	 echo "$(1)" |						  \
> 	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
> 	 rm -f "$$TMP"')
>+
>+# is-absolute
>+# Usage: bool-value =3D $(call is-absolute,path)
>+#
>+define is-absolute
>+$(shell sh -c "echo '$(1)' | grep ^/")
>+endef
>+
>+# lookup
>+# Usage: absolute-executable-path-or-empty =3D $(call lookup,path)
>+#
>+define lookup
>+$(shell sh -c "command -v '$(1)'")
>+endef
>+
>+# is-executable
>+# Usage: bool-value =3D $(call is-executable,path)
>+#
>+define is-executable
>+$(shell sh -c "test -f '$(1)' -a -x '$(1)' && echo y")
>+endef
>+
>+# get-executable
>+# Usage: absolute-executable-path-or-empty =3D $(call get-executable,path)
>+#
>+# The goal is to get an absolute path for an executable;
>+# the `command -v' is defined by POSIX, but it's not
>+# necessarily very portable, so it's only used if
>+# relative path resolution is requested, as determined
>+# by the presence of a leading `/'.
>+#
>+define get-executable
>+$(if $(1),$(if $(call is-absolute,$(1)),$(if $(call is-executable,$(1)),$=
(1)),$(call lookup,$(1))))
>+endef
>+
>+# get-supplied-or-default-executable
>+# Usage: absolute-executable-path-or-empty =3D $(call get-supplied-or-def=
ault-executable,path,default)
>+#
>+define get-supplied-or-default-executable
>+$(if $(1),$(call _attempt,$(1)),$(call _attempt,$(2)))
>+endef
>+define _attempt
>+$(or $(call get-executable,$(1)),$(warning The path '$(1)' is not executa=
ble.))
>+endef
Hi,=20

@Michael, yeah, I use Arch linux too and noticed this issue when
building it. Thanks.

@Arnaldo, the patch submitted by Michael seems to be taking care of far
more cases than mine, so that is much better. I will check my encoding
and/or the signed-off issue next time I submit anything (I had created
it with git format-patch --stdout followed by mutt -H <file>, not sure
whether this messed it up, or Vim did it). Thanks again.

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNkiG8AAoJEKYW3KHXK+l3WwQH/jjmuuFZZOE7PZ9gUBx/prfX
sCgRrjFQgQvWFwDiN+KtKw1G0YxfXQQrSfqR7uG6vxeHrAlWtcEYF90nBCFIybgT
AcbGxXTQOXDFKA5Uv6jFQ3xgfpnfr6wOgzyVe8Iir4+fTTOT1AOXb0ZLy6tvqDq0
JrPQopOO7ZwbLnLLFzy9dD/7myPOR6Cwi+aBDFrcYCqwZLxx+YDFRkzuQdGLMOEG
qhS1+d0lh67D6llrNgzlLF+l6RNdDzJrZC+RNHizX/Sz3a6fgEimIQ59BQYU7tiH
T7B8yUQV/yhPMLEWFI7fbF/nONijQ9kh1eLblmhCJZGpZXL/3srLy8nOEWvEJ2c=
=jqJB
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
