Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab2AWSat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 13:30:49 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42594 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab2AWSar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 13:30:47 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz7B5ebEGKKJmvuWY+2O-6qarUj40CHASu_4EQ0KDgi_Q@mail.gmail.com>
References: <1327139539-14301-1-git-send-email-yinghai@kernel.org>
	<1327139539-14301-2-git-send-email-yinghai@kernel.org>
	<CA+55aFz7B5ebEGKKJmvuWY+2O-6qarUj40CHASu_4EQ0KDgi_Q@mail.gmail.com>
Date: Mon, 23 Jan 2012 10:30:46 -0800
X-Google-Sender-Auth: FWB92jxu63z4G4blhGcgCFT8AAo
Message-ID: <CAE9FiQWbmO+FFsE06eQ=-PVNtdaTG3EsqXNXdUCxb9YxtPS8Cw@mail.gmail.com>
Subject: Re: [PATCH 1/7] PCI: Make sriov work with hotplug remove
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=20cf3079bc649dbe1204b7363a1c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3079bc649dbe1204b7363a1c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 23, 2012 at 8:06 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Jan 21, 2012 at 1:52 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>
>> + =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0* pci_stop_bus_device(dev) will not remove dev from bus=
->devices list,
>> + =A0 =A0 =A0 =A0* =A0so We don't need use _safe version for_each here.
>> + =A0 =A0 =A0 =A0* Also _safe version has problem when pci_stop_bus_devi=
ce() for PF try
>> + =A0 =A0 =A0 =A0* =A0to remove VFs.
>> + =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 for (l =3D head->next; l !=3D head;) {
>
> That's crazy. Why would you open-code this? Why isn't it just a
> "list_for_each()"?

I have previous version used list_for_each(), but Kenji thought we
should open version because it could be clear that l is updated in the
loop.

>
> And what are the problems with the safe version? If the safe version
> doesn't work, then something is *seriously* wrong with the list.

in list_for_each_safe()

#define list_for_each_safe(pos, n, head) \
        for (pos =3D (head)->next, n =3D pos->next; pos !=3D (head); \
                pos =3D n, n =3D pos->next)

n is saved before, and safe only mean pos could be freed from the
list, but n still can be used for next loop.

in our case, the list have PF and several VFs, when
pci_stop_bus_device() is called for PF, pos are still valid, but
VFs are removed from the list. so n will not be valid.

>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct pci_dev *dev =3D pci_dev_b(l);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* VFs are removed by pci_remove_bus_dev=
ice() in the
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* =A0pci_stop_bus_devices() code path f=
or PF.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* =A0aka, bus->devices get updated in t=
he process.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* barrier() will make sure we get right=
 next from that list.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!dev->is_virtfn) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pci_stop_bus_device(dev);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 barrier();
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> And this is just insanity. The "barrier()" cannot *possibly* do
> anything sane. If it really makes a difference, there is again some
> serious problem with the whole f*cking thing.
>
> NAK on the patch until sanity is restored. This is just total voodoo
> programming.

Sorry for that.

Can you please check V1 version ?

https://lkml.org/lkml/2011/10/15/141
or from attached one.

Thanks

Yinghai

--20cf3079bc649dbe1204b7363a1c
Content-Type: text/x-patch; charset=US-ASCII; name="pci_001_debug_sriov_hot_remove.patch"
Content-Disposition: attachment; 
	filename="pci_001_debug_sriov_hot_remove.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gxrtup410

RnJvbTogWWluZ2hhaSBMdSA8eWluZ2hhaUBrZXJuZS5vcmc+ClN1YmplY3Q6IFtQQVRDSCAwMS8x
MF0gUENJOiBNYWtlIHNyaW92IHdvcmsgd2l0aCBob3RwbHVnIHJlbW92ZQoKV2hlbiBob3QgcmVt
b3ZlIHBjaSBleHByZXNzIG1vZHVsZSB0aGF0IGhhdmUgcGNpZSBzd2l0Y2ggYW5kIHN1cHBvcnQg
U1JJT1YsIGdvdAoKWyA1OTE4LjYxMDEyN10gcGNpZWhwIDAwMDA6ODA6MDIuMjpwY2llMDQ6IHBj
aWVfaXNyOiBpbnRyX2xvYyAxClsgNTkxOC42MTU3NzldIHBjaWVocCAwMDAwOjgwOjAyLjI6cGNp
ZTA0OiBBdHRlbnRpb24gYnV0dG9uIGludGVycnVwdCByZWNlaXZlZApbIDU5MTguNjIyNzMwXSBw
Y2llaHAgMDAwMDo4MDowMi4yOnBjaWUwNDogQnV0dG9uIHByZXNzZWQgb24gU2xvdCgzKQpbIDU5
MTguNjI5MDAyXSBwY2llaHAgMDAwMDo4MDowMi4yOnBjaWUwNDogcGNpZWhwX2dldF9wb3dlcl9z
dGF0dXM6IFNMT1RDVFJMIGE4IHZhbHVlIHJlYWQgMWY5ClsgNTkxOC42Mzc0MTZdIHBjaWVocCAw
MDAwOjgwOjAyLjI6cGNpZTA0OiBQQ0kgc2xvdCAjMyAtIHBvd2VyaW5nIG9mZiBkdWUgdG8gYnV0
dG9uIHByZXNzLgpbIDU5MTguNjQ3MTI1XSBwY2llaHAgMDAwMDo4MDowMi4yOnBjaWUwNDogcGNp
ZV9pc3I6IGludHJfbG9jIDEwClsgNTkxOC42NTMwMzldIHBjaWVocCAwMDAwOjgwOjAyLjI6cGNp
ZTA0OiBwY2llaHBfZ3JlZW5fbGVkX2JsaW5rOiBTTE9UQ1RSTCBhOCB3cml0ZSBjbWQgMjAwClsg
NTkxOC42NjEyMjldIHBjaWVocCAwMDAwOjgwOjAyLjI6cGNpZTA0OiBwY2llaHBfc2V0X2F0dGVu
dGlvbl9zdGF0dXM6IFNMT1RDVFJMIGE4IHdyaXRlIGNtZCBjMApbIDU5MjQuNjY3NjI3XSBwY2ll
aHAgMDAwMDo4MDowMi4yOnBjaWUwNDogRGlzYWJsaW5nIGRvbWFpbjpidXM6ZGV2aWNlPTAwMDA6
YjA6MDAKWyA1OTI0LjY3NDkwOV0gcGNpZWhwIDAwMDA6ODA6MDIuMjpwY2llMDQ6IHBjaWVocF9n
ZXRfcG93ZXJfc3RhdHVzOiBTTE9UQ1RSTCBhOCB2YWx1ZSByZWFkIDJmOQpbIDU5MjQuNjgzMjYy
XSBwY2llaHAgMDAwMDo4MDowMi4yOnBjaWUwNDogcGNpZWhwX3VuY29uZmlndXJlX2RldmljZTog
ZG9tYWluOmJ1czpkZXYgPSAwMDAwOmIwOjAwClsgNTkyNC42OTM5NzZdIGxpYmZjb2VfZGV2aWNl
X25vdGlmaWNhdGlvbjogTkVUREVWX1VOUkVHSVNURVIgZXRoNgpbIDU5MjQuNzY0OTc5XSBsaWJm
Y29lX2RldmljZV9ub3RpZmljYXRpb246IE5FVERFVl9VTlJFR0lTVEVSIGV0aDE0ClsgNTkyNC44
NzM1MzldIGxpYmZjb2VfZGV2aWNlX25vdGlmaWNhdGlvbjogTkVUREVWX1VOUkVHSVNURVIgZXRo
MTUKWyA1OTI0Ljk5NTIwOV0gbGliZmNvZV9kZXZpY2Vfbm90aWZpY2F0aW9uOiBORVRERVZfVU5S
RUdJU1RFUiBldGgxNgpbIDU5MjYuMTE0NDA3XSBzeGdlIDAwMDA6YjI6MDAuMDogUENJIElOVCBB
IGRpc2FibGVkClsgNTkyNi4xMTkzNDJdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVM
TCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0IChudWxsKQpbIDU5MjYuMTI3MTg5XSBJUDogWzxmZmZm
ZmZmZjgxMzUzYTNiPl0gcGNpX3N0b3BfYnVzX2RldmljZSsweDMzLzB4ODMKWyA1OTI2LjEzMzM3
N10gUEdEIDAKWyA1OTI2LjEzNTQwMl0gT29wczogMDAwMCBbIzFdIFNNUApbIDU5MjYuMTM4NjU5
XSBDUFUgMgpbIDU5MjYuMTQwNDk5XSBNb2R1bGVzIGxpbmtlZCBpbjoKLi4uClsgNTkyNi4xNDM3
NTRdClsgNTkyNi4yNzU4MjNdIENhbGwgVHJhY2U6ClsgNTkyNi4yNzgyNjddICBbPGZmZmZmZmZm
ODEzNTNhMzg+XSBwY2lfc3RvcF9idXNfZGV2aWNlKzB4MzAvMHg4MwpbIDU5MjYuMjg0MTgwXSAg
WzxmZmZmZmZmZjgxMzUzYWY0Pl0gcGNpX3JlbW92ZV9idXNfZGV2aWNlKzB4MWEvMHhiYQpbIDU5
MjYuMjkwMjY0XSAgWzxmZmZmZmZmZjgxMzY2MzExPl0gcGNpZWhwX3VuY29uZmlndXJlX2Rldmlj
ZSsweDExMC8weDE3YgpbIDU5MjYuMjk2ODY2XSAgWzxmZmZmZmZmZjgxMzY1ZGQ5Pl0gPyBwY2ll
aHBfZGlzYWJsZV9zbG90KzB4MTg4LzB4MTg4ClsgNTkyNi4zMDMxMjNdICBbPGZmZmZmZmZmODEz
NjVkNmY+XSBwY2llaHBfZGlzYWJsZV9zbG90KzB4MTFlLzB4MTg4ClsgNTkyNi4zMDkyMDZdICBb
PGZmZmZmZmZmODEzNjVlNjg+XSBwY2llaHBfcG93ZXJfdGhyZWFkKzB4OGYvMHhlMAouLi4KCiAr
LVswMDAwOjgwXS0rLTAwLjAtWzgxLThmXS0tCiB8ICAgICAgICAgICArLTAxLjAtWzkwLTlmXS0t
CiB8ICAgICAgICAgICArLTAyLjAtW2EwLWFmXS0tCiB8ICAgICAgICAgICArLTAyLjItW2IwLWJm
XS0tLS0wMC4wLVtiMS1iM10tLSstMDIuMC1bYjJdLS0rLTAwLjAgRGV2aWNlCiB8ICAgICAgICAg
ICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAgICAgICArLTAwLjEgRGV2
aWNlCiB8ICAgICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAg
ICAgICArLTAwLjIgRGV2aWNlCiB8ICAgICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHwgICAgICAgICAgICBcLTAwLjMgRGV2aWNlCiB8ICAgICAgICAgICB8ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIFwtMDMuMC1bYjNdLS0rLTAwLjAgRGV2aWNlCiB8ICAgICAg
ICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICArLTAwLjEg
RGV2aWNlCiB8ICAgICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICArLTAwLjIgRGV2aWNlCiB8ICAgICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBcLTAwLjMgRGV2aWNlCgpyb290IGNvbXBsZXg6IDgwOjAy
LjIKcGNpIGV4cHJlc3MgbW9kdWxlczogaGF2ZSBwY2llIHN3aXRjaCBhbmQgYXJlIGxpc3RlZCBh
cyBiMDowMC4wLCBiMTowMi4wIGFuZCBiMTowMy4wLgogICAgICAgICAgICAgICAgZW5kIGRldmlj
ZXMgIGFyZSBiMjowMC4wIGFuZCBiMy4wMC4wLgogICAgICAgICAgICAgICAgVkZzIGFyZTogYjI6
MDAuMSwuLi4gYjI6MDAuMywgYW5kIGIzOjAwLjEsLi4uLGIzOjAwLjMKClJvb3QgY2F1c2U6IHdo
ZW4gZG9pbmcgcGNpX3N0b3BfYnVzX2RldmljZSgpIHdpdGggcGh5cyBmbiwgaXQgd2lsbCBzdG9w
IHZpcnQgZm4gYW5kCnJlbW92ZSB0aGUgZm4sIHNvCglsaXN0X2Zvcl9lYWNoX3NhZmUobCwgbiwg
JmJ1cy0+ZGV2aWNlcykKd2lsbCBoYXZlIHByb2JsZW0gdG8gcmVmZXIgZnJlZWQgbiB0aGF0IGlz
IHBvaW50ZWQgdG8gdmYgZW50cnkuCgpTb2x1dGlvbiBpcyBqdXN0IGNhbGwgcGNpX3N0b3BfYnVz
X2RldmljZSgpIHdpdGggcGh5cyBmbiBvbmx5LiBhbmQgYmVmb3JlIHRoYXQgbmVlZCB0bwpzYXZl
IHBoeXMgZm4gYXNpZGUgYW5kIGF2b2lkIHRvIHVzZSBidXMtPmRldmljZXMgdG8gbG9vcC4KCkR1
cmluZyByZXZpZXdpbmcgdGhlIHBhdGNoLCBCam9ybiBzYWlkOgp8ICAgVGhlIFBDSSBob3QtcmVt
b3ZlIHBhdGggY2FsbHMgcGNpX3N0b3BfYnVzX2RldmljZXMoKSB2aWEKfCAgIHBjaV9yZW1vdmVf
YnVzX2RldmljZSgpLgp8CnwgICBwY2lfc3RvcF9idXNfZGV2aWNlcygpIHRyYXZlcnNlcyB0aGUg
YnVzLT5kZXZpY2VzIGxpc3QgKHBvaW50IEEgYmVsb3cpLAp8ICAgc3RvcHBpbmcgZWFjaCBkZXZp
Y2UgaW4gdHVybiwgd2hpY2ggY2FsbHMgdGhlIGRyaXZlciByZW1vdmUoKSBtZXRob2QuICBXaGVu
CnwgICB0aGUgZGV2aWNlIGlzIGFuIFNSLUlPViBQRiwgdGhlIGRyaXZlciBjYWxscyBwY2lfZGlz
YWJsZV9zcmlvdigpLCB3aGljaAp8ICAgYWxzbyB1c2VzIHBjaV9yZW1vdmVfYnVzX2RldmljZSgp
IHRvIHJlbW92ZSB0aGUgVkYgZGV2aWNlcyBmcm9tIHRoZQp8ICAgYnVzLT5kZXZpY2VzIGxpc3Qg
KHBvaW50IEIpLgp8CnwgICAgICAgcGNpX3JlbW92ZV9idXNfZGV2aWNlCnwgICAgICAgICBwY2lf
c3RvcF9idXNfZGV2aWNlCnwgICAgICAgICAgIHBjaV9zdG9wX2J1c19kZXZpY2VzKHN1Ym9yZGlu
YXRlKQp8ICAgICAgICAgICAgIGxpc3RfZm9yX2VhY2goYnVzLT5kZXZpY2VzKSAgICAgICAgICAg
ICA8LS0gQQp8ICAgICAgICAgICAgICAgcGNpX3N0b3BfYnVzX2RldmljZShQRikKfCAgICAgICAg
ICAgICAgICAgLi4uCnwgICAgICAgICAgICAgICAgICAgZHJpdmVyLT5yZW1vdmUKfCAgICAgICAg
ICAgICAgICAgICAgIHBjaV9kaXNhYmxlX3NyaW92CnwgICAgICAgICAgICAgICAgICAgICAgIC4u
Lgp8ICAgICAgICAgICAgICAgICAgICAgICAgIHBjaV9yZW1vdmVfYnVzX2RldmljZShWRikKfCAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgPHJlbW92ZSBmcm9tIGJ1c19saXN0PiAgPC0tIEIK
fAp8ICAgQXQgQiwgd2UncmUgY2hhbmdpbmcgdGhlIHNhbWUgbGlzdCB3ZSdyZSBpdGVyYXRpbmcg
dGhyb3VnaCBhdCBBLCBzbyB3aGVuCnwgICB0aGUgZHJpdmVyIHJlbW92ZSgpIG1ldGhvZCByZXR1
cm5zLCB0aGUgcGNpX3N0b3BfYnVzX2RldmljZXMoKSBpdGVyYXRvciBoYXMKfCAgIGEgcG9pbnRl
ciB0byBhIGxpc3QgZW50cnkgdGhhdCBoYXMgYWxyZWFkeSBiZWVuIGZyZWVkLgp8CnwgICBUaGlz
IHBhdGNoIGF2b2lkcyB0aGUgcHJvYmxlbSBieSBidWlsZGluZyBhIHNlcGFyYXRlIGxpc3Qgb2Yg
YWxsIFBGcyBvbgp8ICAgdGhlIGJ1cyBhbmQgdHJhdmVyc2luZyB0aGF0IGF0IEEgaW5zdGVhZCBv
ZiB0aGUgYnVzLT5kZXZpY2VzIGxpc3QuCgpEaXNjdXNzaW9uIHRocmVhZCBjYW4gYmUgZm91bmQg
OiBodHRwczovL2xrbWwub3JnL2xrbWwvMjAxMS8xMC8xNS8xNDEKClNpZ25lZC1vZmYtYnk6IFlp
bmdoYWkgTHUgPHlpbmdoYWlAa2VybmVsLm9yZz4KCi0tLQogZHJpdmVycy9wY2kvcmVtb3ZlLmMg
fCAgIDMzICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQs
IDMzIGluc2VydGlvbnMoKykKCkluZGV4OiBsaW51eC0yLjYvZHJpdmVycy9wY2kvcmVtb3ZlLmMK
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvZHJpdmVycy9wY2kvcmVtb3ZlLmMKKysrIGxp
bnV4LTIuNi9kcml2ZXJzL3BjaS9yZW1vdmUuYwpAQCAtMTIwLDEwICsxMjAsNDMgQEAgdm9pZCBw
Y2lfcmVtb3ZlX2JlaGluZF9icmlkZ2Uoc3RydWN0IHBjaQogCQkJcGNpX3JlbW92ZV9idXNfZGV2
aWNlKHBjaV9kZXZfYihsKSk7CiB9CiAKK3N0cnVjdCBkZXZfbGlzdCB7CisJc3RydWN0IHBjaV9k
ZXYgKmRldjsKKwlzdHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7Cit9OworCiBzdGF0aWMgdm9pZCBwY2lf
c3RvcF9idXNfZGV2aWNlcyhzdHJ1Y3QgcGNpX2J1cyAqYnVzKQogewogCXN0cnVjdCBsaXN0X2hl
YWQgKmwsICpuOworCXN0cnVjdCBkZXZfbGlzdCAqZGwsICpkbjsKKwlMSVNUX0hFQUQocGh5c2Zu
X2xpc3QpOworCisJLyogU2F2ZSBwaHlzX2ZuIGFzaWRlIGF0IGZpcnN0ICovCisJbGlzdF9mb3Jf
ZWFjaChsLCAmYnVzLT5kZXZpY2VzKSB7CisJCXN0cnVjdCBwY2lfZGV2ICpkZXYgPSBwY2lfZGV2
X2IobCk7CisKKwkJaWYgKCFkZXYtPmlzX3ZpcnRmbikgeworCQkJZGwgPSBrbWFsbG9jKHNpemVv
ZigqZGwpLCBHRlBfS0VSTkVMKTsKKwkJCWlmICghZGwpCisJCQkJY29udGludWU7CisJCQlkbC0+
ZGV2ID0gZGV2OworCQkJbGlzdF9hZGRfdGFpbCgmZGwtPmxpc3QsICZwaHlzZm5fbGlzdCk7CisJ
CX0KKwl9CisKKwkvKgorCSAqIHN0b3AgYnVzIGRldmljZSBmb3IgcGh5c19mbiBhdCBmaXJzdAor
CSAqICBpdCB3aWxsIHN0b3AgYW5kIHJlbW92ZSB2ZiBpbiBkcml2ZXIgcmVtb3ZlIGFjdGlvbgor
CSAqLworCWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShkbCwgZG4sICZwaHlzZm5fbGlzdCwgbGlz
dCkgeworCQlzdHJ1Y3QgcGNpX2RldiAqZGV2ID0gZGwtPmRldjsKKworCQlwY2lfc3RvcF9idXNf
ZGV2aWNlKGRldik7CisKKwkJa2ZyZWUoZGwpOworCX0KIAorCS8qIERvIGl0IGFnYWluIGZvciBs
ZWZ0IG92ZXIgaW4gY2FzZSAqLwogCWxpc3RfZm9yX2VhY2hfc2FmZShsLCBuLCAmYnVzLT5kZXZp
Y2VzKSB7CiAJCXN0cnVjdCBwY2lfZGV2ICpkZXYgPSBwY2lfZGV2X2IobCk7CiAJCXBjaV9zdG9w
X2J1c19kZXZpY2UoZGV2KTsK
--20cf3079bc649dbe1204b7363a1c--
