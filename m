Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1EJF3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 01:29:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36382 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab1EJF3m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 01:29:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=t3GHfDzJynByLMA95pkPkxKLFBiRvDVU76HuU9YcGu7On5l2HsSB3t/TShSel2cYLL
         Nyvyc4xli3ss/aJKZT20JY5KG8V0VwRQgrFul3fGr+8dUAOUfqmTXnhQoQQe4u8L7p0u
         3b3jI44nEiKrBifqk0SRBdQXmLnf9KE24XPiU=
MIME-Version: 1.0
In-Reply-To: <4DC2EB2B.1050203@greenroomsoftware.com>
References: <1304488750-13606-1-git-send-email-subtil@gmail.com>
 <20110504204807.GB13293@sepie.suse.cz> <20110505090728.GC30678@vostochny.stro.at>
 <4DC2C568.9090803@greenroomsoftware.com> <BANLkTinjBun=TzjveEiJsEJYKH_+NRCP7Q@mail.gmail.com>
 <4DC2EB2B.1050203@greenroomsoftware.com>
From: Nuno Subtil <subtil@gmail.com>
Date: Mon, 9 May 2011 22:29:22 -0700
Message-ID: <BANLkTimApO4j-Hsvo2OCc=PnEdOhHu76OA@mail.gmail.com>
Subject: Re: [PATCH 1/1] deb-pkg: fix cross-compile build
To: Robert Gordon <robert@greenroomsoftware.com>,
        maximilian attems <max@stro.at>, Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like your patch duplicates the arch detection logic that's
already in create_package, except not completely. I think this is not
desirable.

I modified your patch to isolate this logic into a separate function
and respect the KBUILD_DEBARCH override (which mostly means I moved
the original logic into a separate function). This should make your
case work as well, besides respecting the KBUILD_DEBARCH override.

Maks, Michal, can you please take a look at this new patch?

Thanks,
Nuno

On Thu, May 5, 2011 at 11:23, Robert Gordon
<robert@greenroomsoftware.com> wrote:
> On 5/5/11 10:10 AM, Nuno Subtil wrote:
>
> This patch is not meant to fix that case, only the case where
> KBUILD_DEBARCH is used.
>
> KBUILD_DEBARCH seems to be meant to be used as an override for what
> Debian wants to see as the target architecture. Arguably, the right
> thing to do here might be to do the same arch detection sequence
> that's done in create_package(), which looks at UTS_MACHINE first and
> the KBUILD_DEBARCH override after that (though I'm not entirely sure).
>
> This patch only adds the KBUILD_DEBARCH override, but that is still
> better than the current situation. I can easily get the rest in later
> if needed.
>
> Nuno
>
> On Thu, May 5, 2011 at 08:42, Robert Gordon
> <robert@greenroomsoftware.com> wrote:
>
> On 05/05/2011 02:07 AM, maximilian attems wrote:
>
> On Wed, May 04, 2011 at 10:48:07PM +0200, Michal Marek wrote:
>
> Adding Maks to CC.
>
> thanks, this one looks, good please disguard the other patch.
>
> On Tue, May 03, 2011 at 10:59:10PM -0700, Nuno Subtil wrote:
>
> When generating the header package, scripts/package/builddeb was inferring
> the
> target architecture by looking at the output of dpkg --print-architecture.
> This
> allows KBUILD_DEBARCH to override that.
>
> Signed-off-by: Nuno Subtil <subtil@gmail.com>
>
> Acked-by: maximilian attems <max@stro.at>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Greetings,
>
> Compile breaks when using the following command:
>    fakeroot make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- deb-pkg
>
> With 'set -x' in scripts/package/builddeb, the relevant output is:
>    + '[' -n '' ']'
>    ++ dpkg --print-architecture
>    + arch=i386
> This indicates that KBUILD_DEBARCH is not set.
>
> The debian/control file is written with the following section:
>    Package: linux-headers-2.6.39-rc5+
>    Provides: linux-headers, linux-headers-2.6
>    Architecture: i386
>    Description: Linux kernel headers for 2.6.39-rc5+ on i386
>     This package provides kernel header files for 2.6.39-rc5+ on i386
>
> This produces the following error output:
>    + forcearch=-DArchitecture=armel
>    + dpkg-gencontrol -isp -DArchitecture=armel
> -plinux-headers-2.6.39-rc5+ -P/opt/kernel-linus/linux-2.6/debian/hdrtmp
>    dpkg-gencontrol: error: current host architecture 'armel' does not
> appear in package's architecture list (i386)
>
> Regards,
> Robert
>
>
> Nuno,
>      Thanks for the response.  I am very new at this process, but I am
> trying to learn.  Yesterday, I submitted a patch that was intended to
> address the same issue that you have addressed.  I did what you are
> suggesting by mimicking what is done in create_package(), but leaving
> i386/x86_64 untouched.  Here is the subject of the patch I sent:
>
> [PATCH] kbuild, deb-pkg: set host machine $arch correctly when
> cross-compiling or not
>
>      Please advise if I should resend.
>
> Regards,
> Robert
>
> --
>
