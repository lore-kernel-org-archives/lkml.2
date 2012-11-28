Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab2K1THz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:07:55 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40533 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab2K1THy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:07:54 -0500
MIME-Version: 1.0
In-Reply-To: <50B64996.1010709@redhat.com>
References: <50A513A8.9010404@redhat.com> <CA+55aFyLMmKuEvY6T2=vSHp_R4=ndqFEFNJsc3Axze2vYknKhg@mail.gmail.com>
 <50B63A04.9010901@redhat.com> <CA+55aFy7hxayPzr3MiV1xc0bvLcd+-7b52iA3CYhbPZuWXr9yA@mail.gmail.com>
 <50B64996.1010709@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Nov 2012 11:07:32 -0800
X-Google-Sender-Auth: 1s47g94Kid9Zg4ewzkKTVNGxJqU
Message-ID: <CA+55aFz2p2_WUkhThjSDWAFVda6nujxX2YE_Qkqv1OVDChUEJQ@mail.gmail.com>
Subject: Re: Acpi deadlocks with 3.7.0-rc4
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=e89a8f2355c71eeb9e04cf92e20b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f2355c71eeb9e04cf92e20b
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Nov 28, 2012 at 9:27 AM, Zdenek Kabelac <zkabelac@redhat.com> wrote:
>
> I've attached bigger disasfun script output to BZ 51071.
> https://bugzilla.kernel.org/show_bug.cgi?id=51071#c1
>
>
>         if (ACPI_GET_DESCRIPTOR_TYPE(prefix_node) !=
> 00000000000000a1 <acpi_ns_lookup+0xa1> cmpb   $0xf,0x8(%rbx)
> 00000000000000a5 <acpi_ns_lookup+0xa5> je   0da  <acpi_ns_lookup+0xda>
>
> seems to be going out of bounds.

The whole "prefix_node" pointer is bogus. It seems to have the value 0x1000.

I wonder how that happened. It's loaded from 'scope_info->scope.node',
and it *should* be a valid pointer.

Can you add a print-out of

  scope_info->common.descriptor_type

and check that it is ACPI_DESC_TYPE_STATE_WSCOPE (== 8). If it is not,
return early.

Or just something like the attatched, which just uses the root node
(and warns once) if it's not a valid WSCOPE thing.

                       Linus

--e89a8f2355c71eeb9e04cf92e20b
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ha2tt2ni0

IGRyaXZlcnMvYWNwaS9hY3BpY2EvbnNhY2Nlc3MuYyB8IDIgKysKIDEgZmlsZSBjaGFuZ2VkLCAy
IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2FjcGkvYWNwaWNhL25zYWNjZXNz
LmMgYi9kcml2ZXJzL2FjcGkvYWNwaWNhL25zYWNjZXNzLmMKaW5kZXggMjNkYjUzY2UyMjkzLi4z
MjM4Y2FiYmE2MWEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvYWNwaS9hY3BpY2EvbnNhY2Nlc3MuYwor
KysgYi9kcml2ZXJzL2FjcGkvYWNwaWNhL25zYWNjZXNzLmMKQEAgLTMyMCw2ICszMjAsOCBAQCBh
Y3BpX25zX2xvb2t1cCh1bmlvbiBhY3BpX2dlbmVyaWNfc3RhdGUgKnNjb3BlX2luZm8sCiAJCQkJ
ICBhY3BpX2dibF9yb290X25vZGUpKTsKIAogCQlwcmVmaXhfbm9kZSA9IGFjcGlfZ2JsX3Jvb3Rf
bm9kZTsKKwl9IGVsc2UgaWYgKFdBUk5fT05fT05DRShzY29wZV9pbmZvLT5jb21tb24uZGVzY3Jp
cHRvcl90eXBlICE9IEFDUElfREVTQ19UWVBFX1NUQVRFX1dTQ09QRSkpIHsKKwkJcHJlZml4X25v
ZGUgPSBhY3BpX2dibF9yb290X25vZGU7CiAJfSBlbHNlIHsKIAkJcHJlZml4X25vZGUgPSBzY29w
ZV9pbmZvLT5zY29wZS5ub2RlOwogCQlpZiAoQUNQSV9HRVRfREVTQ1JJUFRPUl9UWVBFKHByZWZp
eF9ub2RlKSAhPQo=
--e89a8f2355c71eeb9e04cf92e20b--
