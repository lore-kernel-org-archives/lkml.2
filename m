Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab0EZPNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:13:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:12522 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab0EZPNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:13:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=U+h8Vj8hLtZkVmtRtSjwi9jtUBmRRzH+4tJbyJTHkyE+yZwYtPM/ZaGtIqO2+uiNa2
         w+JY+mHPCtxa7+jkXqLB/hPdDYbABobFKyr4g6vN5rK1JZwlPs7h+x2MoOmb0f3BJKqN
         b+Yr2JEmEdLLRpGHHXWlpykPEI3OL50W6/C08=
Message-ID: <4BFD3AA2.1090904@gmail.com>
Date: Wed, 26 May 2010 17:13:38 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100522 SUSE/3.1rc1-2.1 Thunderbird/3.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: adobriyan@gmail.com, nhorman@tuxdriver.com, oleg@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 10/11] rlimits: implement prlimit64 syscall
References: <1273514451-28894-1-git-send-email-jslaby@suse.cz>	<1273514451-28894-10-git-send-email-jslaby@suse.cz>	<20100513155630.9ca5ab16.akpm@linux-foundation.org>	<4BFD1ADD.7020004@gmail.com> <20100526073045.ea26740f.akpm@linux-foundation.org>
In-Reply-To: <20100526073045.ea26740f.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 04:30 PM, Andrew Morton wrote:
> main()
> {
> 	if (clone(...)) {
> 		while (wait_for_message(&m))
> 			setrlimit(m);
> 	}
> 
> 	...
> }
> 		
> ?

Hmm. Probably I'm still missing something obvious, but how does this
help for existing services like databases and/or closed-source products?

Or do you mean to provide this as a library
(s@main@__attribute__((constructor)) my_main@ then) and link (or even
preload) to the programs people want to change limits on-the-fly in?
(And clone with THREAD flag to share task_struct->signal.)

But this approach can only help for the parent of all the forked-later
processes. Especially if a process forks and exits (i.e. creates a
daemon), the child running in the background doesn't have the
wait_for_message thread. So if it forks again (e.g. to service a new
request) the limits cannot be changed in any of them.

This can be solved by adding such a cloned-thread loop into every forked
child, but I'm not sure this is something we want.

In addition, people don't know which process will need to change limits
in advance. Every single binary would have to contain such code.

-- 
js
