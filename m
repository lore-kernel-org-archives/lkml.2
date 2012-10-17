Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab2JQFSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 01:18:35 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64774 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab2JQFSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 01:18:33 -0400
MIME-Version: 1.0
In-Reply-To: <1350444308-27102-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1350444308-27102-1-git-send-email-tangchen@cn.fujitsu.com>
Date: Tue, 16 Oct 2012 22:18:31 -0700
X-Google-Sender-Auth: MGE2HspWdPdrwMD0VaTK8rkygD8
Message-ID: <CAE9FiQVFc9VVfWZpEfjPeGvo5pby3BQNzDei3VTXdoR048_SPg@mail.gmail.com>
Subject: Re: [PATCH 1/1] Update acpi_root_bridge_list in container hotplug path.
From: Yinghai Lu <yinghai@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: jiang.liu@huawei.com, bhelgaas@google.com, lenb@kernel.org,
        izumi.taku@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015175cd7ead0d16604cc3a663d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015175cd7ead0d16604cc3a663d
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Oct 16, 2012 at 8:25 PM, Tang Chen <tangchen@cn.fujitsu.com> wrote:
> Hi Yinghai,
>
> List acpi_root_bridge_list is only updated when kernel is booting,
> or in _handle_hotplug_event_root() when handling ACPI_NOTIFY_DEVICE_CHECK
> event on a pci root bridge device. But when we hotplug a container, which
> contains one or more pci root bridges, container_notify_cb() will be
> called but not _handle_hotplug_event_root(). As a result,
> acpi_root_bridge_list won't be updated.
>
> This patch makes the following api and struct public in pci_root_hp.h,
>         struct acpi_root_bridge;
>         add_acpi_root_bridge()
>         remove_acpi_root_bridge()
>         acpi_root_handle_to_bridge()
> and call add_acpi_root_bridge() in acpi_bus_check_add() and call
> remove_acpi_root_bridge() in acpi_bus_remove().
>
> This patch is based on Lu Yinghai's git tree branch for-pci-split-pci-root-hp-2.
>
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 6ca2eaf..c258064 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -12,6 +12,7 @@
>  #include <linux/dmi.h>
>
>  #include <acpi/acpi_drivers.h>
> +#include <acpi/pci_root_hp.h>
>
>  #include "internal.h"
>
> @@ -1265,8 +1266,17 @@ int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
>         dev->removal_type = ACPI_BUS_REMOVAL_EJECT;
>         device_release_driver(&dev->dev);
>
> -       if (rmdevice)
> +       if (rmdevice) {
> +               if (acpi_is_root_bridge(dev->handle)) {
> +                       struct acpi_root_bridge *bridge;
> +
> +                       bridge = acpi_root_handle_to_bridge(dev->handle);
> +                       if (bridge)
> +                               remove_acpi_root_bridge(bridge);
> +               }
> +
>                 acpi_device_unregister(dev, ACPI_BUS_REMOVAL_EJECT);
> +       }

no, we don't need that.

after closely looking, it seems we can dump acpi_root_bridge.

please check if attached patch could work with container path.

Thanks

Yinghai

--0015175cd7ead0d16604cc3a663d
Content-Type: application/octet-stream; 
	name="kill_remove_acpi_root_bridge.patch"
Content-Disposition: attachment; 
	filename="kill_remove_acpi_root_bridge.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h8dzpcqj0

U3ViamVjdDogW1BBVENIXSBQQ0ksIEFDUEk6IHJlbW92ZSBhY3BpX3Jvb3RfYnJpZGdlIGluIHBj
aV9yb290X2hwCgpUYW5nIG5vdGljZWQgdGhhdCBob3RwbHVnIHRocm91Z2ggY29udGFpbmVyIHdp
bGwgbm90IHVwZGF0ZSBhY3BpX3Jvb3RfYnJpZGdlCmxpc3QuCgpBZnRlciBjbG9zZWx5IGNoZWNr
aW5nLCB3ZSBkb24ndCBuZWVkIHRoYXQgZm9yIHN0cnVjdCBmb3IgdHJhY2tpbmcgYW5kCmNvdWxk
IHVzZSBhY3BpX3BjaV9yb290IGRpcmVjdGx5LgoKUmVwb3J0ZWQtYnk6IFRhbmcgQ2hlbiA8dGFu
Z2NoZW5AY24uZnVqaXRzdS5jb20+ClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWlA
a2VybmVsLm9yZz4KCi0tLQogZHJpdmVycy9hY3BpL3BjaV9yb290X2hwLmMgfCAgMTExICsrKysr
KysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQs
IDIxIGluc2VydGlvbnMoKyksIDkwIGRlbGV0aW9ucygtKQoKSW5kZXg6IGxpbnV4LTIuNi9kcml2
ZXJzL2FjcGkvcGNpX3Jvb3RfaHAuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9kcml2
ZXJzL2FjcGkvcGNpX3Jvb3RfaHAuYworKysgbGludXgtMi42L2RyaXZlcnMvYWNwaS9wY2lfcm9v
dF9ocC5jCkBAIC0xMiwxMyArMTIsNiBAQAogI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4KICNpbmNs
dWRlIDxsaW51eC9hY3BpLmg+CiAKLXN0YXRpYyBMSVNUX0hFQUQoYWNwaV9yb290X2JyaWRnZV9s
aXN0KTsKLXN0cnVjdCBhY3BpX3Jvb3RfYnJpZGdlIHsKLQlzdHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7
Ci0JYWNwaV9oYW5kbGUgaGFuZGxlOwotCXUzMiBmbGFnczsKLX07Ci0KIHN0YXRpYyBjb25zdCBz
dHJ1Y3QgYWNwaV9kZXZpY2VfaWQgcm9vdF9kZXZpY2VfaWRzW10gPSB7CiAJeyJQTlAwQTAzIiwg
MH0sCiAJeyJQTlAwQTA4IiwgMH0sCkBAIC0zMSw2MCArMjQsNiBAQCBzdGF0aWMgY29uc3Qgc3Ry
dWN0IGFjcGlfZGV2aWNlX2lkIHJvb3RfCiAKICNkZWZpbmUgQUNQSV9TVEFfRlVOQ1RJT05JTkcJ
KDB4MDAwMDAwMDgpCiAKLXN0YXRpYyBzdHJ1Y3QgYWNwaV9yb290X2JyaWRnZSAqYWNwaV9yb290
X2hhbmRsZV90b19icmlkZ2UoYWNwaV9oYW5kbGUgaGFuZGxlKQotewotCXN0cnVjdCBhY3BpX3Jv
b3RfYnJpZGdlICpicmlkZ2U7Ci0KLQlsaXN0X2Zvcl9lYWNoX2VudHJ5KGJyaWRnZSwgJmFjcGlf
cm9vdF9icmlkZ2VfbGlzdCwgbGlzdCkKLQkJaWYgKGJyaWRnZS0+aGFuZGxlID09IGhhbmRsZSkK
LQkJCXJldHVybiBicmlkZ2U7Ci0KLQlyZXR1cm4gTlVMTDsKLX0KLQotLyogYWxsb2NhdGUgYW5k
IGluaXRpYWxpemUgaG9zdCBicmlkZ2UgZGF0YSBzdHJ1Y3R1cmUgKi8KLXN0YXRpYyB2b2lkIGFk
ZF9hY3BpX3Jvb3RfYnJpZGdlKGFjcGlfaGFuZGxlIGhhbmRsZSkKLXsKLQlzdHJ1Y3QgYWNwaV9y
b290X2JyaWRnZSAqYnJpZGdlOwotCWFjcGlfaGFuZGxlIGR1bW15X2hhbmRsZTsKLQlhY3BpX3N0
YXR1cyBzdGF0dXM7Ci0KLQkvKiBpZiB0aGUgYnJpZGdlIGRvZXNuJ3QgaGF2ZSBfU1RBLCB3ZSBh
c3N1bWUgaXQgaXMgYWx3YXlzIHRoZXJlICovCi0Jc3RhdHVzID0gYWNwaV9nZXRfaGFuZGxlKGhh
bmRsZSwgIl9TVEEiLCAmZHVtbXlfaGFuZGxlKTsKLQlpZiAoQUNQSV9TVUNDRVNTKHN0YXR1cykp
IHsKLQkJdW5zaWduZWQgbG9uZyBsb25nIHRtcDsKLQotCQlzdGF0dXMgPSBhY3BpX2V2YWx1YXRl
X2ludGVnZXIoaGFuZGxlLCAiX1NUQSIsIE5VTEwsICZ0bXApOwotCQlpZiAoQUNQSV9GQUlMVVJF
KHN0YXR1cykpIHsKLQkJCXByaW50ayhLRVJOX0RFQlVHICIlczogX1NUQSBldmFsdWF0aW9uIGZh
aWx1cmVcbiIsCi0JCQkJCQkgX19mdW5jX18pOwotCQkJcmV0dXJuOwotCQl9Ci0JCWlmICgodG1w
ICYgQUNQSV9TVEFfRlVOQ1RJT05JTkcpID09IDApCi0JCQkvKiBkb24ndCByZWdpc3RlciB0aGlz
IG9iamVjdCAqLwotCQkJcmV0dXJuOwotCX0KLQotCWJyaWRnZSA9IGt6YWxsb2Moc2l6ZW9mKHN0
cnVjdCBhY3BpX3Jvb3RfYnJpZGdlKSwgR0ZQX0tFUk5FTCk7Ci0JaWYgKCFicmlkZ2UpCi0JCXJl
dHVybjsKLQotCWJyaWRnZS0+aGFuZGxlID0gaGFuZGxlOwotCi0JaWYgKEFDUElfU1VDQ0VTUyhh
Y3BpX2dldF9oYW5kbGUoaGFuZGxlLCAiX0VKMCIsICZkdW1teV9oYW5kbGUpKSkKLQkJYnJpZGdl
LT5mbGFncyB8PSBST09UX0JSSURHRV9IQVNfRUowOwotCWlmIChBQ1BJX1NVQ0NFU1MoYWNwaV9n
ZXRfaGFuZGxlKGhhbmRsZSwgIl9QUzMiLCAmZHVtbXlfaGFuZGxlKSkpCi0JCWJyaWRnZS0+Zmxh
Z3MgfD0gUk9PVF9CUklER0VfSEFTX1BTMzsKLQotCWxpc3RfYWRkKCZicmlkZ2UtPmxpc3QsICZh
Y3BpX3Jvb3RfYnJpZGdlX2xpc3QpOwotfQotCi1zdGF0aWMgdm9pZCByZW1vdmVfYWNwaV9yb290
X2JyaWRnZShzdHJ1Y3QgYWNwaV9yb290X2JyaWRnZSAqYnJpZGdlKQotewotCWxpc3RfZGVsKCZi
cmlkZ2UtPmxpc3QpOwotCWtmcmVlKGJyaWRnZSk7Ci19Ci0KIHN0cnVjdCBhY3BpX3Jvb3RfaHBf
d29yayB7CiAJc3RydWN0IHdvcmtfc3RydWN0IHdvcms7CiAJYWNwaV9oYW5kbGUgaGFuZGxlOwpA
QCAtMTY2LDI4ICsxMDUsMjUgQEAgc3RhdGljIGludCBhY3BpX3Jvb3RfZXZhbHVhdGVfb2JqZWN0
KGFjcAogCXJldHVybiAwOwogfQogCi1zdGF0aWMgdm9pZCBoYW5kbGVfcm9vdF9icmlkZ2VfcmVt
b3ZhbChhY3BpX2hhbmRsZSBoYW5kbGUsCi0JCSBzdHJ1Y3QgYWNwaV9yb290X2JyaWRnZSAqYnJp
ZGdlKQorc3RhdGljIHZvaWQgaGFuZGxlX3Jvb3RfYnJpZGdlX3JlbW92YWwoc3RydWN0IGFjcGlf
ZGV2aWNlICpkZXZpY2UpCiB7CisJaW50IHJldF92YWw7CiAJdTMyIGZsYWdzID0gMDsKLQlzdHJ1
Y3QgYWNwaV9kZXZpY2UgKmRldmljZTsKLQotCWlmIChicmlkZ2UpIHsKLQkJZmxhZ3MgPSBicmlk
Z2UtPmZsYWdzOwotCQlyZW1vdmVfYWNwaV9yb290X2JyaWRnZShicmlkZ2UpOwotCX0KLQotCWlm
ICghYWNwaV9idXNfZ2V0X2RldmljZShoYW5kbGUsICZkZXZpY2UpKSB7Ci0JCWludCByZXRfdmFs
OworCWFjcGlfaGFuZGxlIGR1bW15X2hhbmRsZTsKKwlhY3BpX2hhbmRsZSBoYW5kbGUgPSBkZXZp
Y2UtPmhhbmRsZTsKIAotCQkvKiByZW1vdmUgcGNpIGRldmljZXMgYXQgZmlyc3QgKi8KLQkJcmV0
X3ZhbCA9IGFjcGlfYnVzX3RyaW0oZGV2aWNlLCAwKTsKLQkJcHJpbnRrKEtFUk5fREVCVUcgImFj
cGlfYnVzX3RyaW0gc3RvcCByZXR1cm4gJXhcbiIsIHJldF92YWwpOworCWlmIChBQ1BJX1NVQ0NF
U1MoYWNwaV9nZXRfaGFuZGxlKGhhbmRsZSwgIl9FSjAiLCAmZHVtbXlfaGFuZGxlKSkpCisJCWZs
YWdzIHw9IFJPT1RfQlJJREdFX0hBU19FSjA7CisJaWYgKEFDUElfU1VDQ0VTUyhhY3BpX2dldF9o
YW5kbGUoaGFuZGxlLCAiX1BTMyIsICZkdW1teV9oYW5kbGUpKSkKKwkJZmxhZ3MgfD0gUk9PVF9C
UklER0VfSEFTX1BTMzsKIAotCQkvKiByZW1vdmUgYWNwaSBkZXZpY2VzICovCi0JCXJldF92YWwg
PSBhY3BpX2J1c190cmltKGRldmljZSwgMSk7Ci0JCXByaW50ayhLRVJOX0RFQlVHICJhY3BpX2J1
c190cmltIHJlbW92ZSByZXR1cm4gJXhcbiIsIHJldF92YWwpOwotCX0KKwkvKiByZW1vdmUgcGNp
IGRldmljZXMgYXQgZmlyc3QgKi8KKwlyZXRfdmFsID0gYWNwaV9idXNfdHJpbShkZXZpY2UsIDAp
OworCXByaW50ayhLRVJOX0RFQlVHICJhY3BpX2J1c190cmltIHN0b3AgcmV0dXJuICV4XG4iLCBy
ZXRfdmFsKTsKKworCS8qIHJlbW92ZSBhY3BpIGRldmljZXMgKi8KKwlyZXRfdmFsID0gYWNwaV9i
dXNfdHJpbShkZXZpY2UsIDEpOworCXByaW50ayhLRVJOX0RFQlVHICJhY3BpX2J1c190cmltIHJl
bW92ZSByZXR1cm4gJXhcbiIsIHJldF92YWwpOwogCiAJaWYgKGZsYWdzICYgUk9PVF9CUklER0Vf
SEFTX1BTMykgewogCQlhY3BpX3N0YXR1cyBzdGF0dXM7CkBAIC0yMDIsNyArMTM4LDcgQEAgc3Rh
dGljIHZvaWQgaGFuZGxlX3Jvb3RfYnJpZGdlX3JlbW92YWwoYQogCiBzdGF0aWMgdm9pZCBfaGFu
ZGxlX2hvdHBsdWdfZXZlbnRfcm9vdChzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiB7Ci0Jc3Ry
dWN0IGFjcGlfcm9vdF9icmlkZ2UgKmJyaWRnZTsKKwlzdHJ1Y3QgYWNwaV9wY2lfcm9vdCAqcm9v
dDsKIAljaGFyIG9iam5hbWVbNjRdOwogCXN0cnVjdCBhY3BpX2J1ZmZlciBidWZmZXIgPSB7IC5s
ZW5ndGggPSBzaXplb2Yob2JqbmFtZSksCiAJCQkJICAgICAgLnBvaW50ZXIgPSBvYmpuYW1lIH07
CkBAIC0yMTQsNyArMTUwLDcgQEAgc3RhdGljIHZvaWQgX2hhbmRsZV9ob3RwbHVnX2V2ZW50X3Jv
b3QocwogCWhhbmRsZSA9IGhwX3dvcmstPmhhbmRsZTsKIAl0eXBlID0gaHBfd29yay0+dHlwZTsK
IAotCWJyaWRnZSA9IGFjcGlfcm9vdF9oYW5kbGVfdG9fYnJpZGdlKGhhbmRsZSk7CisJcm9vdCA9
IGFjcGlfcGNpX2ZpbmRfcm9vdChoYW5kbGUpOwogCiAJYWNwaV9nZXRfbmFtZShoYW5kbGUsIEFD
UElfRlVMTF9QQVRITkFNRSwgJmJ1ZmZlcik7CiAKQEAgLTIyMywxMCArMTU5LDggQEAgc3RhdGlj
IHZvaWQgX2hhbmRsZV9ob3RwbHVnX2V2ZW50X3Jvb3QocwogCQkvKiBidXMgZW51bWVyYXRlICov
CiAJCXByaW50ayhLRVJOX0RFQlVHICIlczogQnVzIGNoZWNrIG5vdGlmeSBvbiAlc1xuIiwgX19m
dW5jX18sCiAJCQkJIG9iam5hbWUpOwotCQlpZiAoIWJyaWRnZSkgeworCQlpZiAoIXJvb3QpCiAJ
CQloYW5kbGVfcm9vdF9icmlkZ2VfaW5zZXJ0aW9uKGhhbmRsZSk7Ci0JCQlhZGRfYWNwaV9yb290
X2JyaWRnZShoYW5kbGUpOwotCQl9CiAKIAkJYnJlYWs7CiAKQEAgLTIzNCwxNyArMTY4LDE2IEBA
IHN0YXRpYyB2b2lkIF9oYW5kbGVfaG90cGx1Z19ldmVudF9yb290KHMKIAkJLyogZGV2aWNlIGNo
ZWNrICovCiAJCXByaW50ayhLRVJOX0RFQlVHICIlczogRGV2aWNlIGNoZWNrIG5vdGlmeSBvbiAl
c1xuIiwgX19mdW5jX18sCiAJCQkJIG9iam5hbWUpOwotCQlpZiAoIWJyaWRnZSkgeworCQlpZiAo
IXJvb3QpCiAJCQloYW5kbGVfcm9vdF9icmlkZ2VfaW5zZXJ0aW9uKGhhbmRsZSk7Ci0JCQlhZGRf
YWNwaV9yb290X2JyaWRnZShoYW5kbGUpOwotCQl9CiAJCWJyZWFrOwogCiAJY2FzZSBBQ1BJX05P
VElGWV9FSkVDVF9SRVFVRVNUOgogCQkvKiByZXF1ZXN0IGRldmljZSBlamVjdCAqLwogCQlwcmlu
dGsoS0VSTl9ERUJVRyAiJXM6IERldmljZSBlamVjdCBub3RpZnkgb24gJXNcbiIsIF9fZnVuY19f
LAogCQkJCSBvYmpuYW1lKTsKLQkJaGFuZGxlX3Jvb3RfYnJpZGdlX3JlbW92YWwoaGFuZGxlLCBi
cmlkZ2UpOworCQlpZiAocm9vdCkKKwkJCWhhbmRsZV9yb290X2JyaWRnZV9yZW1vdmFsKHJvb3Qt
PmRldmljZSk7CiAJCWJyZWFrOwogCWRlZmF1bHQ6CiAJCXByaW50ayhLRVJOX1dBUk5JTkcgIm5v
dGlmeV9oYW5kbGVyOiB1bmtub3duIGV2ZW50IHR5cGUgMHgleCBmb3IgJXNcbiIsCkBAIC0zMDQs
OCArMjM3LDYgQEAgZmluZF9yb290X2JyaWRnZXMoYWNwaV9oYW5kbGUgaGFuZGxlLCB1MwogCQlw
cmludGsoS0VSTl9ERUJVRyAiYWNwaSByb290OiAlcyBub3RpZnkgaGFuZGxlciBpcyBpbnN0YWxs
ZWRcbiIsCiAJCQkJIG9iam5hbWUpOwogCi0JYWRkX2FjcGlfcm9vdF9icmlkZ2UoaGFuZGxlKTsK
LQogCXJldHVybiBBRV9PSzsKIH0KIAo=
--0015175cd7ead0d16604cc3a663d--
