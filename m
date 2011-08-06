Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab1HFMpk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 08:45:40 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:60322 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753949Ab1HFMpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 08:45:39 -0400
X-AuditID: 1209190c-b7bdeae000000a26-8e-4e3d371917d7
Message-ID: <4E3D3768.3070108@mit.edu>
Date: Sat, 06 Aug 2011 08:45:28 -0400
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
Newsgroups: gmane.linux.network,gmane.linux.kernel
To: Tejun Heo <tj@kernel.org>
CC: Matt Helsley <matthltc@us.ibm.com>, Pavel Emelyanov <xemul@parallels.com>,
        Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, S@MIT.EDU,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [EXAMPLE CODE] Parasite thread injection and TCP connection hijacking
References: <20110806121247.GC23937@htj.dyndns.org>
In-Reply-To: <20110806121247.GC23937@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsUixCmqrStpbutncGu3tcWc8y0sFjveL2Kx
	uNS7hNXi8q45bBb3Vjxktji2QMyiZeUhdovFk9qZLX4tP8poMfPpRiYHLo+vtw4yeWxZeZPJ
	49rdOo9NqzrZPE7O+8nmcfGSsse5a33MHp83yQVwRHHZpKTmZJalFunbJXBlbDj5hqXgFU/F
	ueV3mRoYu7i6GDk5JARMJN5f284OYYtJXLi3nq2LkYtDSGAfo8SJS1/ZIZz1jBIX7m5ihHDe
	MEksPvmKFaSFV0BNouNrO1g7i4CqxOmGbkYQm01ARaJj6QMmEFtUIEji/u8GFoh6QYmTM5+A
	2XwCRhKbrjSB1YgIyEpcmfYQbAGzQAOzxINpnWBFwkDNN9d1gS0QEjCWuLN8BRuIzQl0989Z
	3UA1HEAN1hLfdheBhJkF5CW2v53DPIFRaBaSdbMQqmYhqVrAyLyKUTYlt0o3NzEzpzg1Wbc4
	OTEvL7VI11AvN7NELzWldBMjOLokeXYwvjmodIhRgINRiYf3oYyNnxBrYllxZe4hRkkOJiVR
	3g3Gtn5CfEn5KZUZicUZ8UWlOanFhxglOJiVRHhzdIHKeVMSK6tSi/JhUtIcLErivOXe/32F
	BNITS1KzU1MLUotgsjIcHEoSvBfNgIYKFqWmp1akZeaUIKSZODhBhvMADQ80BarhLS5IzC3O
	TIfIn2LU5Vj78eNRRiGWvPy8VClx3nsggwRAijJK8+DmwJLiK0ZxoLeEeZfrAFXxABMq3KRX
	QEuYgJbkPgH5oLgkESEl1cC4s+yAyY9b578dKA80CPxV9ldXY2GMmYiE0pJVe6ui7/Jt55gr
	4Fb35OusHod9qjdr3OSKTm99vrb7RfePVzu3G0jZaFS1HpM0ig/gc/fYXLb23kdHKS2esq0i
	s1k2hE9xNjv1QKXsYeK5k/wKx60bQu7suxcW8Mrz/rKvWuZXQnhE2F9YadxVYinOSDTUYi4q
	TgQAD6Nq6mUDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2011 08:12 AM, Tejun Heo wrote:
> Hello, guys.
>
> So, here's transparent TCP connection hijacking (ie. checkpointing in
> one process and restoring in another) which adds only relatively small
> pieces to the kernel.  It's by no means complete but already works
> rather reliably in my test setup even with heavy delay induced with
> tc.
>
> I wrote a rather long README describing how it's working, what's
> missing which is appended at the end of this mail so if you're
> interested in the details please go ahead and read.

That's a little gross but quite cool.

I think you have an annoying corner case, though:

 > 2. Decide where to inject the foreign code and save the original code
 >    with PTRACE_PEEKDATA.  Tracer can poke any mapped area regardless
 >    of protection flags but it can't add execution permission to the
 >    code, so it needs to choose memory area which already has X flag
 >    set.  The example code uses the page the %rip is in.

If the process is executing from the vsyscall page, then you'll probably 
fail.  (Admittedly, this is rather unlikely, given that the vsyscalls 
are now exactly one instruction.)  Presumably you also fail if executing 
from a read-only MAP_SHARED mapping.

Windows has a facility to more-or-less call mmap on behalf of another 
process, and another one to directly inject a thread into a remote 
process.  It's traditional to use them for this type of manipulation. 
Perhaps Linux should get the same thing.  (Although you could accomplish 
much the same thing if you could create a task with your mm but the 
tracee's fs.)

--Andy
