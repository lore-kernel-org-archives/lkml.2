Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab2D1ADt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 20:03:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41615 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757659Ab2D1ADs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 20:03:48 -0400
Message-ID: <4F9B33BF.908@zytor.com>
Date: Fri, 27 Apr 2012 17:03:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, mjt@tls.msk.ru,
        linux-kernel@vger.kernel.org, autofs@vger.kernel.org, raven@themaw.net,
        thomas@m3y3r.de, stable@kernel.org
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix design
 error.
References: <20120427.151433.1007849975903946491.davem@davemloft.net> <20120427.151651.2274764174217164454.davem@davemloft.net> <CA+55aFzPbAprx-iT0TYh24uS7+JnL92mbTg_js6Cd_O0q+Dvmw@mail.gmail.com> <20120427.152404.2292425516870981391.davem@davemloft.net> <CA+55aFzGO+PHmjjVgxnYawbB-wFAqHtkh19vTv1AwQNpc9MsWg@mail.gmail.com> <4F9B050C.3000309@zytor.com> <CA+55aFz-1n=REkh9SzA1aEz5J_uGc=B_nKj+cP8J=PR6YSZD1w@mail.gmail.com> <4F9B2420.5030806@zytor.com> <CA+55aFyCpiU5_nG-3Nra5q9x0-71amAQVetZTxxP6waR1ueYNQ@mail.gmail.com>
In-Reply-To: <CA+55aFyCpiU5_nG-3Nra5q9x0-71amAQVetZTxxP6waR1ueYNQ@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 04:07 PM, Linus Torvalds wrote:
> 
> The important change is actually to make the read return the size requested.
> 
> So broken user space does a read() with the wrong size - and then
> checks that it gets *exactly* that many bytes. Not more, not less.
> 
> The way to handle that is to
>  - make sure the kernel always writes the maximally padded data
>  - make the packetization simply drop any data that was in the packet
> that the reader didn't ask for.
> 
> This is very much a semantic change, in that any client that tries to
> read the packet with multiple reads (one 4-byte read to see the size,
> followed by one "right-sized" read of the data) would be totally
> screwed. The first read would indeed read the size, but it also -
> because of the packetized interface - would simply drop the data, and
> the next read would read the first bytes of the next packet.
> 
> But that's not what the autofs users actually do anyway. They just
> read the whole packet.  So we can make *them* work. And the new
> interface will be fairly robust (in fact, you could pass it some big
> buffer and just know you always get exactly one packet, and never have
> that whole stupid "sizeof()" at all).
> 

OK, I follow you now.  That would work for autofs; I presume it is not
something we would export to other users though?  If so I'd worry about
opening up new security issues.

Still, I have to admit... we have a grand total of three users of this
interface as far as we know (autofs, systemd, and am-utils if they ever
revved that one to v5.)  Would it really not be better to do the
zero-eating user space fix?

	-hpa


