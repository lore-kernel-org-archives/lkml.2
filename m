Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab1DIUli (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 16:41:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63620 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757435Ab1DIUlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 16:41:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:date:from:to:cc:message-id:in-reply-to:references;
        b=A/2esnltJtguQDXMEJAkDR3Nf1jbMG9PV3LwiIjI8QI/3l+hBcQ2Hor9X39oh0lsrH
         YrkZwYjgPVIN/+Y5vpWTK2iy2THBCHoJvMDaPmdav19S2aXEh4j8f3uyBpLA/vxO55hA
         63poeCSzSuJ2Smn8uWiMlN3cNgj3dd+Yr8WQY=
Subject: Re: [PATCH] Use the environment variable PYTHON if defined
Date: Sat, 09 Apr 2011 20:34:10 +0000
From: Michael Witten <mfwitten@gmail.com>
To: Raghavendra D Prabhu <rprabhu@wnohang.net>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Message-ID: <7f7c5d35-e644-4950-a3d3-dfcf46d5237e-mfwitten@gmail.com>
In-Reply-To: <20110409184245.GA5115@Xye>
References: <20110326224408.GA1336@Xye>
            <20110328144721.GB17872@ghostprotocols.net>
            <e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com>
            <20110329181524.GA5140@Xye>
            <AANLkTi=3Wq3Xt-QFR-FLRQ1kBjpWjaBZNFpOiE_T15WH@mail.gmail.com>
            <20110329204024.GA20824@ghostprotocols.net>
            <3a97df19-e376-412a-95be-37ffde765cc3-mfwitten@gmail.com>
            <20110408211709.GA5155@Xye>
            <5f5948dd-2c38-4ed3-8544-99c137204d07-mfwitten@gmail.com>
            <20110409184245.GA5115@Xye>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Apr 2011 00:12:45 +0530, Raghavendra D Prabhu wrote:

> I have a question regarding the message that is displayed.
> It says "No Python.h found" when variable PYTHON is not set
> correctly, it would be better if it said "No Python.h for
> Python 2.x found" since the header file supplied by Py3k is
> also Python.h and in the rare case of only Py3k installed on
> the box, it may be confusing.

Well...

If PYTHON or PYTHON_CONFIG don't point to an executable, then
there is a complaint about no executable being found.

If PYTHON (or, more specifically, PYTHON_CONFIG) points to the
Python *3* binary, then the message will be about Python 3 being
incompatible.

If PYTHON or PYTHON_CONFIG point to an executable that does not
provide a suitable `Python.h', then it says `No Python.h found'.

Thus, I think all of the cases are covered pretty well.
In particular, let's say that somebody triggers the third case,
but is confused because he does indeed have Python 3 with a valid
Python.h installed. That `No Python.h found' message will cause
him to look at how he configured PYTHON{,_CONFIG}, and he'll
see that he used the wrong executable (which is probably a
fairly unlikely scenario, anyway). Thus, he will configure the
right variable to point to the Python 3 executable, only to
get a message that Python 3 is incompatible. Thus, he will then
know that Python 2 is required.

I suppose, though, we could simplify the experience for the user
by giving a hint earlier on that Python 2 is required.

The patch that follows fulfills your request. My advice is to
save this email to /tmp/email and then apply it over the last
couple of patches like this:

  $ git apply /tmp/email
  $ git commit -a --amend -C HEAD

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1fd46bf..b5276c7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -522,7 +522,7 @@ else
       FLAGS_PYTHON_EMBED := $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
 
       ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
-        $(call disable-python,Python.h)
+        $(call disable-python,Python.h (for Python 2.x))
       else
 
         ifneq ($(call try-cc,$(SOURCE_PYTHON_VERSION),$(FLAGS_PYTHON_EMBED)),y)
