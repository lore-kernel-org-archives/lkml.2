Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab1KXAiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 19:38:00 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52354 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab1KXAh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 19:37:59 -0500
Message-ID: <4ECD91E4.5090504@gmail.com>
Date: Wed, 23 Nov 2011 16:37:56 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Daney <ddaney.cavm@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, DM <dm.n9107@gmail.com>,
        David Howells <dhowells@redhat.com>,
        David Daney <david.daney@cavium.com>,
        "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>
Subject: Re: [PATCH v3 0/2] Stop some of the abuse of BUG() where compile
 time checks should be used.
References: <1322092017-21471-1-git-send-email-ddaney.cavm@gmail.com>  <CA+55aFwjUVhff6jADOSvAn=t4CTVf4ZODTNm7M6vYcmG6TikPA@mail.gmail.com>
In-Reply-To: <CA+55aFwjUVhff6jADOSvAn=t4CTVf4ZODTNm7M6vYcmG6TikPA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 03:57 PM, Linus Torvalds wrote:
> Btw, would it possibly make sense to make the string more useful?
>
> For example using __FILE__ and __LINE__, or possibly letting the user
> of the BUILD_BUG() give a string ("Using HMASK without
> CONFIG_HUGEPAGE").

We thought about doing that, but without doing some complex preprocessor 
fu, the GCC attribute ((error())) thing doesn't do what we want.

It appears that if more than a single instance of the construct is used 
in a compilation unit, the string emitted by the compiler for any of the 
violations will be the last string encountered.

So if you did something like:

.
.
.
Line 99:  BUILD_BUG("You failed on line 99");
.
.
.
.
Line 666: BUILD_BUG("You failed on line 666");
.
.
.

The message emitted for a failure at line 99 would be "You failed on 
line 666".  Which is probably worse than no message at all.

It may be possible to do something like:

#define _LINENAME_CONCAT( _name_, _line_ ) _name_##_line_
#define _LINENAME(_name_, _line_) _LINENAME_CONCAT(_name_,_line_)

#define _BUILD_BUG(MSG,FUBAR)		\
do {					\
   extern void FUBAR (void)		\
      __linktime_error("BUILD_BUG failed: " MSG); \
   FUBAR ();				\
} while (0)

#define BUILD_BUG(M,A) _BUILD_BUG(M, _LINENAME(__build_bug_failed,__LINE__))

But it didn't seem worth it.

>
> Whatever. It's bikeshedding - what would probably be more important
> would be to get this into linux-next so that we find out whether there
> are any compile issues with it on other platforms or compiler
> versions.
>
>                    Linus
>

