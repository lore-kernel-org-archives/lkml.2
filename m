Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761211Ab0HMAWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 20:22:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63266 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab0HMAWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 20:22:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RS/MuiwUaCYVZNoiIB0acsnGOL8GHPAE5C4rwVksgAC66qmL3AV5Dshah5qb5fyLVR
         k9US4NQLU0MvA5+tL5ICMloh98cGBw4dHgLQU/XV+2ul+h3WwpmWFUjChYcCyY89ZaIo
         D8m8S77QCJbu+16KHsDWsv2fox1nVdf+B4XeM=
MIME-Version: 1.0
In-Reply-To: <20100812164557.5f2513a6@virtuousgeek.org>
References: <1281066910.2168.10.camel@pasglop>
	<AANLkTinmhGPHQDX0gmnY9j+K61abgnukw2DrTBG3EUuJ@mail.gmail.com>
	<AANLkTi=BowHspOUSDmwkdN3o9qhh6rJtEZwCnTRP-VrS@mail.gmail.com>
	<20100812164557.5f2513a6@virtuousgeek.org>
Date: Fri, 13 Aug 2010 10:22:17 +1000
Message-ID: <AANLkTik+MX8cKz6hWyaa8Z2gK7fehXzjSPpeiyExuMjb@mail.gmail.com>
Subject: Re: [PATCH] drm: Fix support for PCI domains
From: Dave Airlie <airlied@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        dri-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001485f1dcf6aad711048da97969
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001485f1dcf6aad711048da97969
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 13, 2010 at 9:45 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wr=
ote:
> On Fri, 13 Aug 2010 09:33:35 +1000
> Dave Airlie <airlied@gmail.com> wrote:
>
>> On Fri, Aug 13, 2010 at 7:30 AM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>> > On Fri, Aug 6, 2010 at 05:55, Benjamin Herrenschmidt
>> > <benh@kernel.crashing.org> wrote:
>> >> (For some reason I thought that went in ages ago ...)
>> >>
>> >> This fixes support for PCI domains in what should hopefully be a back=
ward
>> >> compatible way along with a change to libdrm.
>> >>
>> >> When the interface version is set to 1.4, we assume userspace underst=
ands
>> >> domains and the world is at peace. We thus pass proper domain numbers
>> >> instead of 0 to userspace.
>> >>
>> >> The newer libdrm will then try 1.4 first, and fallback to 1.1, along =
with
>> >> ignoring domains in the later case (well, except on alpha of course)
>> >>
>> >> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> >> ---
>> >> =A0drivers/gpu/drm/drm_ioctl.c | =A0 =A01 +
>> >> =A0include/drm/drmP.h =A0 =A0 =A0 =A0 =A0| =A0 18 +++++++++++++-----
>> >> =A0include/drm/drm_core.h =A0 =A0 =A0| =A0 =A02 +-
>> >> =A03 files changed, 15 insertions(+), 6 deletions(-)
>> >
>> >> diff --git a/include/drm/drmP.h b/include/drm/drmP.h
>> >> index c1b9871..6d4bad5 100644
>> >> --- a/include/drm/drmP.h
>> >> +++ b/include/drm/drmP.h
>> >> @@ -1071,11 +1071,19 @@ static __inline__ int drm_core_check_feature(=
struct drm_device *dev,
>> >> =A0 =A0 =A0 =A0return ((dev->driver->driver_features & feature) ? 1 :=
 0);
>> >> =A0}
>> >>
>> >> -#ifdef __alpha__
>> >> -#define drm_get_pci_domain(dev) dev->hose->index
>> >> -#else
>> >> -#define drm_get_pci_domain(dev) 0
>> >> -#endif
>> >> +static inline int drm_get_pci_domain(struct drm_device *dev)
>> >> +{
>> >> +#ifndef __alpha__
>> >> + =A0 =A0 =A0 /* For historical reasons, drm_get_pci_domain() is bust=
icated
>> >> + =A0 =A0 =A0 =A0* on most archs and has to remain so for userspace i=
nterface
>> >> + =A0 =A0 =A0 =A0* < 1.4, except on alpha which was right from the be=
ginning
>> >> + =A0 =A0 =A0 =A0*/
>> >> + =A0 =A0 =A0 if (dev->if_version < 0x10004)
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> >> +#endif /* __alpha__ */
>> >> +
>> >> + =A0 =A0 =A0 return pci_domain_nr(dev->pdev->bus);
>> >
>> > error: implicit declaration of function =91pci_domain_nr=92
>> > on m68k without PCI.
>>
>> I don't think I want to add an ifdef CONFIG_PCI into the drm layer for
>> this, since we seem to be okay everywhere else,
>>
>> lets ask jbarnes, not sure if its safe to just add this to the
>> !CONFIG_PCI section of the linux/pci.h
>
> Hm, so pci_domain_nr should just return 0 on platforms where
> CONFIG_PCI_DOMAINS isn't set. =A0I'd expect that to be the case when
> CONFIG_PCI=3Dn... =A0Maybe we just need to shuffle the definition around?

I suspect something like the attached would suffice.

Or maybe moving the CONFIG_PCI_DOMAINS checkout outside CONFIG_PCI.

Dave.

--001485f1dcf6aad711048da97969
Content-Type: application/octet-stream; name=mydiff
Content-Disposition: attachment; filename=mydiff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gcsam7cm0

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvcGNpLmggYi9pbmNsdWRlL2xpbnV4L3BjaS5oCmlu
ZGV4IGYyNmZkYTcuLmI2Y2I1ZjYgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvcGNpLmgKKysr
IGIvaW5jbHVkZS9saW51eC9wY2kuaApAQCAtMTIxMiw2ICsxMjEyLDkgQEAgc3RhdGljIGlubGlu
ZSBzdHJ1Y3QgcGNpX2RldiAqcGNpX2dldF9idXNfYW5kX3Nsb3QodW5zaWduZWQgaW50IGJ1cywK
IAkJCQkJCXVuc2lnbmVkIGludCBkZXZmbikKIHsgcmV0dXJuIE5VTEw7IH0KIAorc3RhdGljIGlu
bGluZSBpbnQgcGNpX2RvbWFpbl9ucihzdHJ1Y3QgcGNpX2J1cyAqYnVzKQoreyByZXR1cm4gMDsg
fQorCiAjZGVmaW5lIGRldl9pc19wY2koZCkgKGZhbHNlKQogI2RlZmluZSBkZXZfaXNfcGYoZCkg
KGZhbHNlKQogI2RlZmluZSBkZXZfbnVtX3ZmKGQpICgwKQo=
--001485f1dcf6aad711048da97969--
