Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab0FAFFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 01:05:49 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64465 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab0FAFFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 01:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=dEcA5/hv0mV1AJseHlfnlXupS4CO/KrHmkUcBPrDw88NX4gGbSaIRNplgvgihlLcJU
         6SfTe/3+HIczAX8WLIKyTSszvZ/I8aHFfj/n3tFP+vH8E/t0qp05k3q94ps6zL4VFMAl
         5BG0IREZVFkZnPhfoKTXHlPrdWLnJTq33GXBo=
MIME-Version: 1.0
From: Frank Pan <frankpzh@gmail.com>
Date: Tue, 1 Jun 2010 13:05:25 +0800
Message-ID: <AANLkTimTm57fvumRXo9pegOY2M78mduBsClwYlmAOzpo@mail.gmail.com>
Subject: Add a helper function in PCI IOV to get VF device
To: Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Yu Zhao <yu.zhao@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       Mitch Williams <mitch.a.williams@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David S. Miller" <davem@davemloft.net>,
       Matt Carlson <mcarlson@broadcom.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cd287e01118520487f0edd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd287e01118520487f0edd6
Content-Type: text/plain; charset=ISO-8859-1

Greetings,

The motivation is make VF device visible to PF driver. PF driver
may need this to access VF's PCI configuration.
Another use case is in sysfs symbolic linking. Some of VF's sysfs
entries are created by PF driver. For example, /sys/class/net/ethx/vfx
in Intel 82576 NIC driver. Makeing a symbolic link from VF's pci device
to this path also must be done in PF's driver.

Currently, there is no hint about VF's bus/devfn in PF's pci_dev.
The offset and stride entries(which are used to calculate bus/devfn
of VF devices) in VF's PCI configuration is also invisible in PF's
driver. So IMO this helper function is needed.

Any reply is appreciated, THX.

(ps: gmail will do line wrap/tab replace, use attachment instead to patch)

--
Frank Pan

Computer Science and Technology
Tsinghua University

Signed-off-by: Frank Pan <frankpzh@gmail.com>
---
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index ce6a366..f15aa2a 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -722,6 +722,18 @@ int pci_num_vf(struct pci_dev *dev)
 }
 EXPORT_SYMBOL_GPL(pci_num_vf);

+/**
+ * pci_get_vf_dev - return the PCI device of a specific VF
+ * @dev: the PCI device
+ */
+struct pci_dev *pci_get_vf_dev(struct pci_dev *dev, int id)
+{
+       return pci_get_bus_and_slot(
+               virtfn_bus(dev, id),
+               virtfn_devfn(dev, id));
+}
+EXPORT_SYMBOL_GPL(pci_get_vf_dev);
+
 static int ats_alloc_one(struct pci_dev *dev, int ps)
 {
       int pos;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index a327322..fb6010b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1374,6 +1374,7 @@ extern int pci_enable_sriov(struct pci_dev *dev,
int nr_virtfn);
 extern void pci_disable_sriov(struct pci_dev *dev);
 extern irqreturn_t pci_sriov_migration(struct pci_dev *dev);
 extern int pci_num_vf(struct pci_dev *dev);
+extern struct pci_dev *pci_get_vf_dev(struct pci_dev *dev, int id);
 #else
 static inline int pci_enable_sriov(struct pci_dev *dev, int nr_virtfn)
 {
@@ -1390,6 +1391,10 @@ static inline int pci_num_vf(struct pci_dev *dev)
 {
       return 0;
 }
+static inline struct pci_dev *pci_get_vf_dev(struct pci_dev *dev, int id)
+{
+       return NULL;
+}
 #endif

 #if defined(CONFIG_HOTPLUG_PCI) || defined(CONFIG_HOTPLUG_PCI_MODULE)

--000e0cd287e01118520487f0edd6
Content-Type: application/octet-stream; name="iov.patch"
Content-Disposition: attachment; filename="iov.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g9w9i80w0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNpL2lvdi5jIGIvZHJpdmVycy9wY2kvaW92LmMNCmluZGV4
IGNlNmEzNjYuLmYxNWFhMmEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3BjaS9pb3YuYw0KKysrIGIv
ZHJpdmVycy9wY2kvaW92LmMNCkBAIC03MjIsNiArNzIyLDE4IEBAIGludCBwY2lfbnVtX3ZmKHN0
cnVjdCBwY2lfZGV2ICpkZXYpDQogfQ0KIEVYUE9SVF9TWU1CT0xfR1BMKHBjaV9udW1fdmYpOw0K
IA0KKy8qKg0KKyAqIHBjaV9nZXRfdmZfZGV2IC0gcmV0dXJuIHRoZSBQQ0kgZGV2aWNlIG9mIGEg
c3BlY2lmaWMgVkYNCisgKiBAZGV2OiB0aGUgUENJIGRldmljZQ0KKyAqLw0KK3N0cnVjdCBwY2lf
ZGV2ICpwY2lfZ2V0X3ZmX2RldihzdHJ1Y3QgcGNpX2RldiAqZGV2LCBpbnQgaWQpDQorew0KKwly
ZXR1cm4gcGNpX2dldF9idXNfYW5kX3Nsb3QoDQorCQl2aXJ0Zm5fYnVzKGRldiwgaWQpLA0KKwkJ
dmlydGZuX2RldmZuKGRldiwgaWQpKTsNCit9DQorRVhQT1JUX1NZTUJPTF9HUEwocGNpX2dldF92
Zl9kZXYpOw0KKw0KIHN0YXRpYyBpbnQgYXRzX2FsbG9jX29uZShzdHJ1Y3QgcGNpX2RldiAqZGV2
LCBpbnQgcHMpDQogew0KIAlpbnQgcG9zOw0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvcGNp
LmggYi9pbmNsdWRlL2xpbnV4L3BjaS5oDQppbmRleCBhMzI3MzIyLi5mYjYwMTBiIDEwMDY0NA0K
LS0tIGEvaW5jbHVkZS9saW51eC9wY2kuaA0KKysrIGIvaW5jbHVkZS9saW51eC9wY2kuaA0KQEAg
LTEzNzQsNiArMTM3NCw3IEBAIGV4dGVybiBpbnQgcGNpX2VuYWJsZV9zcmlvdihzdHJ1Y3QgcGNp
X2RldiAqZGV2LCBpbnQgbnJfdmlydGZuKTsNCiBleHRlcm4gdm9pZCBwY2lfZGlzYWJsZV9zcmlv
dihzdHJ1Y3QgcGNpX2RldiAqZGV2KTsNCiBleHRlcm4gaXJxcmV0dXJuX3QgcGNpX3NyaW92X21p
Z3JhdGlvbihzdHJ1Y3QgcGNpX2RldiAqZGV2KTsNCiBleHRlcm4gaW50IHBjaV9udW1fdmYoc3Ry
dWN0IHBjaV9kZXYgKmRldik7DQorZXh0ZXJuIHN0cnVjdCBwY2lfZGV2ICpwY2lfZ2V0X3ZmX2Rl
dihzdHJ1Y3QgcGNpX2RldiAqZGV2LCBpbnQgaWQpOw0KICNlbHNlDQogc3RhdGljIGlubGluZSBp
bnQgcGNpX2VuYWJsZV9zcmlvdihzdHJ1Y3QgcGNpX2RldiAqZGV2LCBpbnQgbnJfdmlydGZuKQ0K
IHsNCkBAIC0xMzkwLDYgKzEzOTEsMTAgQEAgc3RhdGljIGlubGluZSBpbnQgcGNpX251bV92Zihz
dHJ1Y3QgcGNpX2RldiAqZGV2KQ0KIHsNCiAJcmV0dXJuIDA7DQogfQ0KK3N0YXRpYyBpbmxpbmUg
c3RydWN0IHBjaV9kZXYgKnBjaV9nZXRfdmZfZGV2KHN0cnVjdCBwY2lfZGV2ICpkZXYsIGludCBp
ZCkNCit7DQorCXJldHVybiBOVUxMOw0KK30NCiAjZW5kaWYNCiANCiAjaWYgZGVmaW5lZChDT05G
SUdfSE9UUExVR19QQ0kpIHx8IGRlZmluZWQoQ09ORklHX0hPVFBMVUdfUENJX01PRFVMRSkNCg==
--000e0cd287e01118520487f0edd6--
