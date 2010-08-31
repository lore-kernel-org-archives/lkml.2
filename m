Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab0HaGfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:35:38 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51172 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097Ab0HaGfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:35:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "M. Vefa Bicakci" <bicave@superonline.com>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causeshibernation to hang
Cc: kosaki.motohiro@jp.fujitsu.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4C7BE25B.1020504@superonline.com>
References: <20100830083704.5231.A69D9226@jp.fujitsu.com> <4C7BE25B.1020504@superonline.com>
Message-Id: <20100831091909.87C1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------_4C7C4A7D0000000087E9_MULTIPART_MIXED_"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 31 Aug 2010 15:35:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------_4C7C4A7D0000000087E9_MULTIPART_MIXED_
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit

> On 30/08/10 05:28 AM, KOSAKI Motohiro wrote:
> >> [snip]
> >>
> >> The interesting thing is that even though there is a lot of free memory at the
> >> end, it still hangs. 
> > 
> > Grr. I'm surprised this result ;-)
> > shrink_all_memory() finish to shrink memory successfully. but your
> > system still hang immediately after. I have no idea why this mysterious
> > occur. 
> > 
> > I prepared next debugging patch. It added prenty debug printk. I hope
> > it enlighten up which path makes system hang-up.
> > 
> > 1. apply my new patch
> > 
> > 2. Enable following PM debug option in Kconfig
> > 
> >   [*] Power Management support
> >   [*]   Power Management Debug Support
> >   [*]     Extra PM attributes in sysfs for low-level debugging/testing
> >   [*]     Verbose Power Management debugging
> > 
> > 3. append following kernel boot option into grub configration file
> > 
> > 	no_console_suspend=1
> > 
> > 3. kernel build and reboot
> > 4. some prepare
> >    # echo 8 > /proc/sysrq-trigger
> >    # cd /sys/power
> >    # echo 1 > pm_trace
> >    # echo 0 > pm_async
> > 
> > 5. run your test program
> > 
> > 
> >> I also included the timestamps; note the one and two second
> >> delays between the passes.
> > 
> > This is expected result because tmpfs shrink need swap-out. then
> > we need i/o time.
> > 
> >>
> >> Please let me know if there is anything I can do.
> > 
> > Please send me your .config and full dmesg.
> > 
> > 
> > Thanks many and many help us!
> 
> Hello,
> 
> I have followed your instructions, with one exception: I have also
> enabled CONFIG_PM_TRACE so that I would have /sys/power/pm_trace.
> 
> This time I had some more output, as expected. I double checked what
> I typed while looking at the screen-shot I took with my camera. Here's
> the output:
> 
> === 8< ===
> PM: Marking nosave pages: ...0009f000 - ...000100000
> PM: basic memory bitmaps created
> PM: Syncing filesystems ... done
> Freezing user space processes ... (elapsed 0.01 seconds) done.
> Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> PM: Preallocating image memory...
> shrink_all_memory start
> PM: shrink memory: pass=1, req:310171 reclaimed:15492 free:360936
> PM: shrink memory: pass=2, req:294679 reclaimed:28864 free:373981
> PM: shrink memory: pass=3, req:265815 reclaimed:60311 free:405374
> PM: shrink memory: pass=4, req:205504 reclaimed:97870 free:443024
> PM: shrink memory: pass=5, req:107634 reclaimed:146948 free:492141
> shrink_all_memory: req:107634 reclaimed:146948 free:492141
> PM: preallocate_image_highmem 556658 278329
> PM: preallocate_image_memory 103139 103139
> PM: preallocate_highmem_fraction 183908 556658 760831 -> 183908
> === >8 ===
> 
> According to your patch, the next output should have been
> "preallocate_image_memory ...", but it never gets printed, so the
> hang point should be that function.

Great!
I've attached more verbose debug message patch and trial bug fixing patch.
Could you please to try this?



> I am attaching my dmesg output which I got after the failed hibernation
> attempt and my .config file. Please note that the attached .config file
> is a trimmed version of the .config I usually use on my computer. I trimmed
> it so that it compiles faster, but (mostly) has support for devices I might
> use.
> 
> Thanks a lot for your help, and please let me know if I can do anything else.
> 


--------_4C7C4A7D0000000087E9_MULTIPART_MIXED_
Content-Type: application/octet-stream;
 name="0001-debug2.patch"
Content-Disposition: attachment;
 filename="0001-debug2.patch"
Content-Transfer-Encoding: base64

RnJvbSBjM2E5M2I4NjVlNzZhZmQwMmJmMzg1NmM2M2M1MGRkOTQ5M2FmYWZkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBLT1NBS0kgTW90b2hpcm8gPGtvc2FraS5tb3RvaGlyb0BqcC5m
dWppdHN1LmNvbT4KRGF0ZTogVHVlLCAzMSBBdWcgMjAxMCAxMzoxMDoxNSArMDkwMApTdWJqZWN0
OiBbUEFUQ0ggMS8yXSBkZWJ1ZzIKCi0tLQoga2VybmVsL3Bvd2VyL3NuYXBzaG90LmMgfCAgIDY2
ICsrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZXMg
Y2hhbmdlZCwgNDAgaW5zZXJ0aW9ucygrKSwgMjYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
a2VybmVsL3Bvd2VyL3NuYXBzaG90LmMgYi9rZXJuZWwvcG93ZXIvc25hcHNob3QuYwppbmRleCBj
ODY0ODA2Li4zMTQ0YWI0IDEwMDY0NAotLS0gYS9rZXJuZWwvcG93ZXIvc25hcHNob3QuYworKysg
Yi9rZXJuZWwvcG93ZXIvc25hcHNob3QuYwpAQCAtMTI1OCwxMCArMTI1OCwxMyBAQCBzdGF0aWMg
dW5zaWduZWQgbG9uZyBtaW5pbXVtX2ltYWdlX3NpemUodW5zaWduZWQgbG9uZyBzYXZlYWJsZSkK
IGludCBoaWJlcm5hdGVfcHJlYWxsb2NhdGVfbWVtb3J5KHZvaWQpCiB7CiAJc3RydWN0IHpvbmUg
KnpvbmU7Ci0JdW5zaWduZWQgbG9uZyBzYXZlYWJsZSwgc2l6ZSwgbWF4X3NpemUsIGNvdW50LCBo
aWdobWVtLCBwYWdlcyA9IDA7CisJdW5zaWduZWQgbG9uZyBzYXZlYWJsZSwgbWF4X3NpemUsIGNv
dW50LCBoaWdobWVtLCBwYWdlcyA9IDA7CiAJdW5zaWduZWQgbG9uZyBhbGxvYywgc2F2ZV9oaWdo
bWVtLCBwYWdlc19oaWdobWVtOwogCXN0cnVjdCB0aW1ldmFsIHN0YXJ0LCBzdG9wOwogCWludCBl
cnJvcjsKKwl1bnNpZ25lZCBsb25nIGFkZGl0aW9uYWxfc2l6ZSwgaW1nX3NpemU7CisJdW5zaWdu
ZWQgbG9uZyBwYWdlc19mcmFjdGlvbjsKKwl1bnNpZ25lZCBsb25nIGltZ19wYWdlczsKIAogCXBy
aW50ayhLRVJOX0lORk8gIlBNOiBQcmVhbGxvY2F0aW5nIGltYWdlIG1lbW9yeS4uLiBcbiIpOwog
CWRvX2dldHRpbWVvZmRheSgmc3RhcnQpOwpAQCAtMTI4OCw5ICsxMjkxLDkgQEAgaW50IGhpYmVy
bmF0ZV9wcmVhbGxvY2F0ZV9tZW1vcnkodm9pZCkKIAljb3VudCA9IHNhdmVhYmxlOwogCXNhdmVh
YmxlICs9IHNhdmVfaGlnaG1lbTsKIAloaWdobWVtID0gc2F2ZV9oaWdobWVtOwotCXNpemUgPSAw
OworCWFkZGl0aW9uYWxfc2l6ZSA9IDA7CiAJZm9yX2VhY2hfcG9wdWxhdGVkX3pvbmUoem9uZSkg
ewotCQlzaXplICs9IHNuYXBzaG90X2FkZGl0aW9uYWxfcGFnZXMoem9uZSk7CisJCWFkZGl0aW9u
YWxfc2l6ZSArPSBzbmFwc2hvdF9hZGRpdGlvbmFsX3BhZ2VzKHpvbmUpOwogCQlpZiAoaXNfaGln
aG1lbSh6b25lKSkKIAkJCWhpZ2htZW0gKz0gem9uZV9wYWdlX3N0YXRlKHpvbmUsIE5SX0ZSRUVf
UEFHRVMpOwogCQllbHNlCkBAIC0xMjk5LDE2ICsxMzAyLDIzIEBAIGludCBoaWJlcm5hdGVfcHJl
YWxsb2NhdGVfbWVtb3J5KHZvaWQpCiAJY291bnQgKz0gaGlnaG1lbTsKIAljb3VudCAtPSB0b3Rh
bHJlc2VydmVfcGFnZXM7CiAKKwlwcmludGsoS0VSTl9JTkZPICJQTTogc2F2ZV9oaWdobWVtKCVs
dSksIHNhdmVhYmxlKCVsdSkgY291bnQ9KCVsdSlcbiIsCisJICAgICAgIHNhdmVfaGlnaG1lbSwg
c2F2ZWFibGUsIGNvdW50KTsKKwogCS8qIENvbXB1dGUgdGhlIG1heGltdW0gbnVtYmVyIG9mIHNh
dmVhYmxlIHBhZ2VzIHRvIGxlYXZlIGluIG1lbW9yeS4gKi8KLQltYXhfc2l6ZSA9IChjb3VudCAt
IChzaXplICsgUEFHRVNfRk9SX0lPKSkgLyAyIC0gMiAqIFNQQVJFX1BBR0VTOwotCXNpemUgPSBE
SVZfUk9VTkRfVVAoaW1hZ2Vfc2l6ZSwgUEFHRV9TSVpFKTsKLQlpZiAoc2l6ZSA+IG1heF9zaXpl
KQotCQlzaXplID0gbWF4X3NpemU7CisJbWF4X3NpemUgPSAoY291bnQgLSAoYWRkaXRpb25hbF9z
aXplICsgUEFHRVNfRk9SX0lPKSkgLyAyIC0gMiAqIFNQQVJFX1BBR0VTOworCWltZ19zaXplID0g
RElWX1JPVU5EX1VQKGltYWdlX3NpemUsIFBBR0VfU0laRSk7CisJaWYgKGltZ19zaXplID4gbWF4
X3NpemUpCisJCWltZ19zaXplID0gbWF4X3NpemU7CisKKwlwcmludGsoS0VSTl9JTkZPICJQTTog
bWF4X3NpemUoJWx1KSwgaW1hZ2Vfc2l6ZSglbHUpLCBpbWdfc2l6ZSglbHUpXG4iLAorCSAgICAg
ICBtYXhfc2l6ZSwgaW1hZ2Vfc2l6ZSwgaW1nX3NpemUpOworCiAJLyoKIAkgKiBJZiB0aGUgbWF4
aW11bSBpcyBub3QgbGVzcyB0aGFuIHRoZSBjdXJyZW50IG51bWJlciBvZiBzYXZlYWJsZSBwYWdl
cwogCSAqIGluIG1lbW9yeSwgYWxsb2NhdGUgcGFnZSBmcmFtZXMgZm9yIHRoZSBpbWFnZSBhbmQg
d2UncmUgZG9uZS4KIAkgKi8KLQlpZiAoc2l6ZSA+PSBzYXZlYWJsZSkgeworCWlmIChpbWdfc2l6
ZSA+PSBzYXZlYWJsZSkgewogCQlwcmludGsoS0VSTl9JTkZPICJQTTogc2l6ZSA+PSBzYXZlYWJs
ZS4gc2tpcCBcbiIpOwogCQlwYWdlcyA9IHByZWFsbG9jYXRlX2ltYWdlX2hpZ2htZW0oc2F2ZV9o
aWdobWVtKTsKIAkJcGFnZXMgKz0gcHJlYWxsb2NhdGVfaW1hZ2VfbWVtb3J5KHNhdmVhYmxlIC0g
cGFnZXMpOwpAQCAtMTMxNiw5ICsxMzI2LDEyIEBAIGludCBoaWJlcm5hdGVfcHJlYWxsb2NhdGVf
bWVtb3J5KHZvaWQpCiAJfQogCiAJLyogRXN0aW1hdGUgdGhlIG1pbmltdW0gc2l6ZSBvZiB0aGUg
aW1hZ2UuICovCi0JcGFnZXMgPSBtaW5pbXVtX2ltYWdlX3NpemUoc2F2ZWFibGUpOwotCWlmIChz
aXplIDwgcGFnZXMpCi0JCXNpemUgPSBtaW5fdCh1bnNpZ25lZCBsb25nLCBwYWdlcywgbWF4X3Np
emUpOworCWltZ19wYWdlcyA9IG1pbmltdW1faW1hZ2Vfc2l6ZShzYXZlYWJsZSk7CisJaWYgKGlt
Z19zaXplIDwgaW1nX3BhZ2VzKQorCQlpbWdfc2l6ZSA9IG1pbl90KHVuc2lnbmVkIGxvbmcsIGlt
Z19wYWdlcywgbWF4X3NpemUpOworCisJcHJpbnRrKEtFUk5fSU5GTyAiUE06IGltZ19wYWdlcygl
bHUpLCBpbWdfc2l6ZSglbHUpXG4iLAorCSAgICAgICBpbWdfcGFnZXMsIGltZ19zaXplKTsKIAog
CS8qCiAJICogTGV0IHRoZSBtZW1vcnkgbWFuYWdlbWVudCBzdWJzeXN0ZW0ga25vdyB0aGF0IHdl
J3JlIGdvaW5nIHRvIG5lZWQgYQpAQCAtMTMyNiw3ICsxMzM5LDcgQEAgaW50IGhpYmVybmF0ZV9w
cmVhbGxvY2F0ZV9tZW1vcnkodm9pZCkKIAkgKiBOT1RFOiBJZiB0aGlzIGlzIG5vdCBkb25lLCBw
ZXJmb3JtYW5jZSB3aWxsIGJlIGh1cnQgYmFkbHkgaW4gc29tZQogCSAqIHRlc3QgY2FzZXMuCiAJ
ICovCi0Jc2hyaW5rX2FsbF9tZW1vcnkoc2F2ZWFibGUgLSBzaXplKTsKKwlzaHJpbmtfYWxsX21l
bW9yeShzYXZlYWJsZSAtIGltZ19zaXplKTsKIAogCS8qCiAJICogVGhlIG51bWJlciBvZiBzYXZl
YWJsZSBwYWdlcyBpbiBtZW1vcnkgd2FzIHRvbyBoaWdoLCBzbyBhcHBseSBzb21lCkBAIC0xMzM2
LDMwICsxMzQ5LDMxIEBAIGludCBoaWJlcm5hdGVfcHJlYWxsb2NhdGVfbWVtb3J5KHZvaWQpCiAJ
ICogaGlnaG1lbSBhbmQgbm9uLWhpZ2htZW0gem9uZXMgc2VwYXJhdGVseS4KIAkgKi8KIAlwYWdl
c19oaWdobWVtID0gcHJlYWxsb2NhdGVfaW1hZ2VfaGlnaG1lbShoaWdobWVtIC8gMik7Ci0JcHJp
bnRrKEtFUk5fSU5GTyAiUE06IHByZWFsbG9jYXRlX2ltYWdlX2hpZ2htZW0gJWx1ICVsdVxuIiwK
LQkgICAgICAgaGlnaG1lbSwgcGFnZXNfaGlnaG1lbSk7CisJcHJpbnRrKEtFUk5fSU5GTyAiUE06
IHByZWFsbG9jYXRlX2ltYWdlX2hpZ2htZW0gJWx1ICVsdSBmcmVlKCV1LyVsdSlcbiIsCisJICAg
ICAgIGhpZ2htZW0sIHBhZ2VzX2hpZ2htZW0sIG5yX2ZyZWVfaGlnaHBhZ2VzKCksIGdsb2JhbF9w
YWdlX3N0YXRlKE5SX0ZSRUVfUEFHRVMpKTsKIAogCWFsbG9jID0gKGNvdW50IC0gbWF4X3NpemUp
IC0gcGFnZXNfaGlnaG1lbTsKIAlwYWdlcyA9IHByZWFsbG9jYXRlX2ltYWdlX21lbW9yeShhbGxv
Yyk7Ci0JcHJpbnRrKEtFUk5fSU5GTyAiUE06IHByZWFsbG9jYXRlX2ltYWdlX21lbW9yeSAlbHUg
JWx1XG4iLAotCSAgICAgICBhbGxvYywgcGFnZXMpOworCXByaW50ayhLRVJOX0lORk8gIlBNOiBw
cmVhbGxvY2F0ZV9pbWFnZV9tZW1vcnkgJWx1ICVsdSBmcmVlKCV1LyVsdSlcbiIsCisJICAgICAg
IGFsbG9jLCBwYWdlcywgbnJfZnJlZV9oaWdocGFnZXMoKSwgZ2xvYmFsX3BhZ2Vfc3RhdGUoTlJf
RlJFRV9QQUdFUykpOwogCiAJaWYgKHBhZ2VzIDwgYWxsb2MpIHsKIAkJcHJpbnRrKEtFUk5fSU5G
TyAiUE06IHBhZ2VzKCVsdSkgPCBhbGxvYyglbHUpLiBlcnJvci4gXG4iLAogCQkgICAgICAgcGFn
ZXMsIGFsbG9jKTsKIAkJZ290byBlcnJfb3V0OwogCX0KLQlzaXplID0gbWF4X3NpemUgLSBzaXpl
OwotCWFsbG9jID0gc2l6ZTsKLQlzaXplID0gcHJlYWxsb2NhdGVfaGlnaG1lbV9mcmFjdGlvbihz
aXplLCBoaWdobWVtLCBjb3VudCk7Ci0JcHJpbnRrKEtFUk5fSU5GTyAiUE06IHByZWFsbG9jYXRl
X2hpZ2htZW1fZnJhY3Rpb24gJWx1ICVsdSAlbHUgLT4gJWx1XG4iLAotCSAgICAgICBzaXplLCBo
aWdobWVtLCBjb3VudCwgc2l6ZSk7Ci0KLQlwYWdlc19oaWdobWVtICs9IHNpemU7Ci0JYWxsb2Mg
LT0gc2l6ZTsKKworCWFsbG9jID0gbWF4X3NpemUgLSBpbWdfc2l6ZTsKKworCXBhZ2VzX2ZyYWN0
aW9uID0gcHJlYWxsb2NhdGVfaGlnaG1lbV9mcmFjdGlvbihhbGxvYywgaGlnaG1lbSwgY291bnQp
OworCXByaW50ayhLRVJOX0lORk8gIlBNOiBwcmVhbGxvY2F0ZV9oaWdobWVtX2ZyYWN0aW9uICVs
dSAlbHUgJWx1IC0+ICVsdSBmcmVlKCV1LyVsdSlcbiIsCisJICAgICAgIGFsbG9jLCBoaWdobWVt
LCBjb3VudCwgcGFnZXNfZnJhY3Rpb24sIG5yX2ZyZWVfaGlnaHBhZ2VzKCksIGdsb2JhbF9wYWdl
X3N0YXRlKE5SX0ZSRUVfUEFHRVMpKTsKKworCXBhZ2VzX2hpZ2htZW0gKz0gcGFnZXNfZnJhY3Rp
b247CisJYWxsb2MgLT0gcGFnZXNfZnJhY3Rpb247CiAJcGFnZXMgKz0gcHJlYWxsb2NhdGVfaW1h
Z2VfbWVtb3J5KGFsbG9jKTsKLQlwcmludGsoS0VSTl9JTkZPICJQTTogcHJlYWxsb2NhdGVfaW1h
Z2VfbWVtb3J5ICVsdSAlbHVcbiIsCi0JICAgICAgIGFsbG9jLCBwYWdlcyk7CisJcHJpbnRrKEtF
Uk5fSU5GTyAiUE06IHByZWFsbG9jYXRlX2ltYWdlX21lbW9yeSAlbHUgJWx1IGZyZWUoJXUvJWx1
KVxuIiwKKwkgICAgICAgYWxsb2MsIHBhZ2VzLCBucl9mcmVlX2hpZ2hwYWdlcygpLCBnbG9iYWxf
cGFnZV9zdGF0ZShOUl9GUkVFX1BBR0VTKSk7CiAJcGFnZXMgKz0gcGFnZXNfaGlnaG1lbTsKIAog
CS8qCi0tIAoxLjYuNS4yCgo=
--------_4C7C4A7D0000000087E9_MULTIPART_MIXED_
Content-Type: application/octet-stream;
 name="0002-add-gfp_noretry.patch"
Content-Disposition: attachment;
 filename="0002-add-gfp_noretry.patch"
Content-Transfer-Encoding: base64

RnJvbSA1NjFiZjRlZWQ0OGNlOTliZDhkOGI5MzMzOTA2MDNmODRhYzRjYWNiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBLT1NBS0kgTW90b2hpcm8gPGtvc2FraS5tb3RvaGlyb0BqcC5m
dWppdHN1LmNvbT4KRGF0ZTogVHVlLCAzMSBBdWcgMjAxMCAxNDo1ODowNCArMDkwMApTdWJqZWN0
OiBbUEFUQ0ggMi8yXSBhZGQgZ2ZwX25vcmV0cnkKClNpZ25lZC1vZmYtYnk6IEtPU0FLSSBNb3Rv
aGlybyA8a29zYWtpLm1vdG9oaXJvQGpwLmZ1aml0c3UuY29tPgotLS0KIGtlcm5lbC9wb3dlci9z
bmFwc2hvdC5jIHwgICAgMiArLQogMSBmaWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbnMoKyksIDEg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEva2VybmVsL3Bvd2VyL3NuYXBzaG90LmMgYi9rZXJu
ZWwvcG93ZXIvc25hcHNob3QuYwppbmRleCAzMTQ0YWI0Li5jNDg4NzA0IDEwMDY0NAotLS0gYS9r
ZXJuZWwvcG93ZXIvc25hcHNob3QuYworKysgYi9rZXJuZWwvcG93ZXIvc25hcHNob3QuYwpAQCAt
MTA5MSw3ICsxMDkxLDcgQEAgdm9pZCBzd3N1c3BfZnJlZSh2b2lkKQogCiAvKiBIZWxwZXIgZnVu
Y3Rpb25zIHVzZWQgZm9yIHRoZSBzaHJpbmtpbmcgb2YgbWVtb3J5LiAqLwogCi0jZGVmaW5lIEdG
UF9JTUFHRQkoR0ZQX0tFUk5FTCB8IF9fR0ZQX05PV0FSTikKKyNkZWZpbmUgR0ZQX0lNQUdFCShH
RlBfS0VSTkVMIHwgX19HRlBfTk9XQVJOIHwgX19HRlBfTk9SRVRSWSkKIAogLyoqCiAgKiBwcmVh
bGxvY2F0ZV9pbWFnZV9wYWdlcyAtIEFsbG9jYXRlIGEgbnVtYmVyIG9mIHBhZ2VzIGZvciBoaWJl
cm5hdGlvbiBpbWFnZQotLSAKMS42LjUuMgoK
--------_4C7C4A7D0000000087E9_MULTIPART_MIXED_--


