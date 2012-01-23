Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab2AWSuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 13:50:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54548 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801Ab2AWSt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 13:49:58 -0500
Message-ID: <4F1DAB99.4060008@zytor.com>
Date: Mon, 23 Jan 2012 10:48:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v4
References: <20120123142036.025893883@openvz.org> <20120123142436.258631438@openvz.org>
In-Reply-To: <20120123142436.258631438@openvz.org>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2012 06:20 AM, Cyrill Gorcunov wrote:
> +
> +static unsigned long cookies[KCMP_TYPES][2] __read_mostly;
> +
> +static long kptr_obfuscate(long v, int type)
> +{
> +	return (v + cookies[type][0]) ^ cookies[type][1];
> +}
> +

Arf... when I said to use xor I meant instead of the add, not instead of
the multiply, so:

	return (v ^ cookies[type][0]) * cookies[type][1];

Otherwise you have absolutely no source of diffusion at all (symmetric
cryptography is about combinations of diffusion -- spreading the content
-- and confusion -- scrambling individual bits of content.)

+	for (i = 0; i < KCMP_TYPES; i++) {
+		for (j = 0; j < 2; j++) {
+			get_random_bytes(&cookies[i][j],
+					 sizeof(cookies[i][j]));
+			cookies[i][j] |= (~(~0UL >>  1) | 1);
+		}
+	}

Only cookies[1] -- being used as a multiplicative constant -- needs the OR.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

