Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab2HMPD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 11:03:29 -0400
Received: from powered.by.root24.eu ([91.121.15.64]:42788 "EHLO Root24.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab2HMPD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 11:03:28 -0400
Message-ID: <5029173C.90709@ionic.de>
Date: Mon, 13 Aug 2012 17:03:24 +0200
From: Mihai Moldovan <ionic@ionic.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Jani Nikula <jani.nikula@intel.com>
CC: daniel@ffwll.ch, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] hopefully fix null pointer dereference on i915 load
References: <50254887.6030209@ionic.de> <cover.1344867962.git.jani.nikula@intel.com>
In-Reply-To: <cover.1344867962.git.jani.nikula@intel.com>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030904050005020508020405"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms030904050005020508020405
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Jani,

* On 13.08.2012 04:33 PM, Jani Nikula wrote:
> Hi Mihai, could you test the following patch to see if it fixes the pro=
blem,
> please?
>
> BR,
> Jani.
>
>
> Jani Nikula (1):
>   drm/i915: ensure i2c adapter is all set before adding it
>
>  drivers/gpu/drm/i915/intel_i2c.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>

The reason sounds sane to me, but while looking through the code, I have =
seen a
few other problems, too.

To my understanding, we should use port for dev_priv->gmbus[], not the pi=
n
mapping (which is only used for gmbus_ports[]).
Don't forget to add the +1 for pin -> port mapping to the error case.

Also, intel_gmbus_get_adapter is already accepting a port value (I made s=
ure to
look at the calls in other files too), so don't map the port back to a pi=
n.

Keep the same in mind for the intel_teardown_gmbus "destructor".

The current code adds the gmbus algorithm (gmbus_xfer) to gmbus port 0, w=
hich is
known as "disabled" and shouldn't be used (previously has_gpio was set to=
 false
for those ports to not do any transfer on those ports.)

I may be wrong, could you review this and maybe add it to your patch?


diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/inte=
l_i2c.c
index 1991a44..b725993 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -472,8 +474,8 @@ int intel_setup_gmbus(struct drm_device *dev)
        mutex_init(&dev_priv->gmbus_mutex);

        for (i =3D 0; i < GMBUS_NUM_PORTS; i++) {
-               struct intel_gmbus *bus =3D &dev_priv->gmbus[i];
                u32 port =3D i + 1; /* +1 to map gmbus index to pin pair =
*/
+               struct intel_gmbus *bus =3D &dev_priv->gmbus[port];

                bus->adapter.owner =3D THIS_MODULE;
                bus->adapter.class =3D I2C_CLASS_DDC;
@@ -506,7 +508,7 @@ int intel_setup_gmbus(struct drm_device *dev)

 err:
        while (--i) {
-               struct intel_gmbus *bus =3D &dev_priv->gmbus[i];
+               struct intel_gmbus *bus =3D &dev_priv->gmbus[i + 1];
                i2c_del_adapter(&bus->adapter);
        }
        return ret;
@@ -516,9 +518,8 @@ struct i2c_adapter *intel_gmbus_get_adapter(struct
drm_i915_private *dev_priv,
                                            unsigned port)
 {
        WARN_ON(!intel_gmbus_is_port_valid(port));
-       /* -1 to map pin pair to gmbus index */
        return (intel_gmbus_is_port_valid(port)) ?
-               &dev_priv->gmbus[port - 1].adapter : NULL;
+               &dev_priv->gmbus[port].adapter : NULL;
 }

 void intel_gmbus_set_speed(struct i2c_adapter *adapter, int speed)
@@ -543,8 +544,9 @@ void intel_teardown_gmbus(struct drm_device *dev)
        if (dev_priv->gmbus =3D=3D NULL)
                return;

+        /* +1 to map gmbus index to pin pair */
        for (i =3D 0; i < GMBUS_NUM_PORTS; i++) {
-               struct intel_gmbus *bus =3D &dev_priv->gmbus[i];
+               struct intel_gmbus *bus =3D &dev_priv->gmbus[i + 1];
                i2c_del_adapter(&bus->adapter);
        }
 }




--------------ms030904050005020508020405
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIINgjCC
BjQwggQcoAMCAQICASAwDQYJKoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA3
MTAyNDIxMDI1NVoXDTE3MTAyNDIxMDI1NVowgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
dGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWdu
aW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENs
aWVudCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMsohUWcASz7GfKrpTOM
KqANy9BV7V0igWdGxA8IU77L3aTxErQ+fcxtDYZ36Z6GH0YFn7fq5RADteP0AYzrCA+EQTfi
8q1+kA3m0nwtwXG94M5sIqsvs7lRP1aycBke/s5g9hJHryZ2acScnzczjBCAo7X1v5G3yw8M
DP2m2RCye0KfgZ4nODerZJVzhAlOD9YejvAXZqHksw56HzElVIoYSZ3q4+RJuPXXfIoyby+Y
2m1E+YzX5iCZXBx05gk6MKAW1vaw4/v2OOLy6FZH3XHHtOkzUreG//CsFnB9+uaYSlR65cdG
zTsmoIK8WH1ygoXhRBm98SD7Hf/r3FELNvUCAwEAAaOCAa0wggGpMA8GA1UdEwEB/wQFMAMB
Af8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBSuVYNv7DHKufcd+q9rMfPIHeOsuzAfBgNV
HSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jBmBggrBgEFBQcBAQRaMFgwJwYIKwYBBQUH
MAGGG2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9jYTAtBggrBgEFBQcwAoYhaHR0cDovL3d3
dy5zdGFydHNzbC5jb20vc2ZzY2EuY3J0MFsGA1UdHwRUMFIwJ6AloCOGIWh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL3Nmc2NhLmNybDAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5jb20v
c2ZzY2EuY3JsMIGABgNVHSAEeTB3MHUGCysGAQQBgbU3AQIBMGYwLgYIKwYBBQUHAgEWImh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93
d3cuc3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwDQYJKoZIhvcNAQEFBQADggIBADqp
Jw3I07QWke9plNBpxUxcffc7nUrIQpJHDci91DFG7fVhHRkMZ1J+BKg5UNUxIFJ2Z9B90Mic
c/NXcs7kPBRdn6XGO/vPc87Y6R+cWS9Nc9+fp3Enmsm94OxOwI9wn8qnr/6o3mD4noP9Jphw
UPTXwHovjavRnhUQHLfo/i2NG0XXgTHXS2Xm0kVUozXqpYpAdumMiB/vezj1QHQJDmUdPYMc
p+reg9901zkyT3fDW/ivJVv6pWtkh6Pw2ytZT7mvg7YhX3V50Nv860cV11mocUVcqBLv0gcT
+HBDYtbuvexNftwNQKD5193A7zN4vG7CTYkXxytSjKuXrpEatEiFPxWgb84nVj25SU5q/r1X
hwby6mLhkbaXslkVtwEWT3Van49rKjlK4XrUKYYWtnfzq6aSak5u0Vpxd1rY79tWhD3EdCvO
hNz/QplNa+VkIsrcp7+8ZhP1l1b2U6MaxIVteuVMD3X0vziIwr7jxYae9FZjbxlpUemqXjcC
0QaFfN7qI0JsQMALL7iGRBg7K0CoOBzECdD3fuZil5kU/LP9cr1BK31U0Uy651bFnAMMMkqh
AChIbn0ei72VnbpSsrrSdF0BAGYQ8vyHae5aCg+H75dVCV33K6FuxZrf09yTz+Vx/PkdRUYk
XmZz/OTfyJXsUOUXrym6KvI2rYpccSk5MIIHRjCCBi6gAwIBAgICHn8wDQYJKoZIhvcNAQEF
BQAwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJT
ZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBD
bGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQTAeFw0xMjAzMjEyMzU3NTda
Fw0xNDAzMjMxNTE0MzlaMIGRMRkwFwYDVQQNExAwSjh4RlU1aWNwTGFuNHlLMQswCQYDVQQG
EwJERTEbMBkGA1UECBMSQmFkZW4tV3VlcnR0ZW1iZXJnMRIwEAYDVQQHEwlLYXJsc3J1aGUx
FzAVBgNVBAMTDk1paGFpIE1vbGRvdmFuMR0wGwYJKoZIhvcNAQkBFg5pb25pY0Bpb25pYy5k
ZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMaylRRCBj2U12flvhmZMgwADN/0
P/ej3O9uLe8XWsr6McU8my6GYxfTXFxfcLl8MxqugflmQQqq1c1Qt69n3zHi+qTvZnHBCBHs
G1CkuL3Of7Srx6ulz0/zgNRMlDnJ7EUAIQDoYkUzn69y/4ap3n/nQf7EmO9o3FnSCX27td5Y
J21uJp/PLvbwvG9kdWMVeiyBubwdBSoMu1D9Cy6YlqFE1DIgPO9RR6EOkie4BgMr/3eliAoK
j7HAOkFhsqTrVy81YtxQDYNrpeMZ2imSQUP1wN1X0NNkdcIWpUNYkRdvzrmpFXxYNhwPPPiE
BIKctzMt00Pss2ziyMqpkQFzcI8CAwEAAaOCA6kwggOlMAkGA1UdEwQCMAAwCwYDVR0PBAQD
AgSwMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQUypNX2Sx5I6PQ
yCj0Lgno1pTiwnswHwYDVR0jBBgwFoAUrlWDb+wxyrn3HfqvazHzyB3jrLswGQYDVR0RBBIw
EIEOaW9uaWNAaW9uaWMuZGUwggIhBgNVHSAEggIYMIICFDCCAhAGCysGAQQBgbU3AQICMIIB
/zAuBggrBgEFBQcCARYiaHR0cDovL3d3dy5zdGFydHNzbC5jb20vcG9saWN5LnBkZjA0Bggr
BgEFBQcCARYoaHR0cDovL3d3dy5zdGFydHNzbC5jb20vaW50ZXJtZWRpYXRlLnBkZjCB9wYI
KwYBBQUHAgIwgeowJxYgU3RhcnRDb20gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwAwIBARqB
vlRoaXMgY2VydGlmaWNhdGUgd2FzIGlzc3VlZCBhY2NvcmRpbmcgdG8gdGhlIENsYXNzIDIg
VmFsaWRhdGlvbiByZXF1aXJlbWVudHMgb2YgdGhlIFN0YXJ0Q29tIENBIHBvbGljeSwgcmVs
aWFuY2Ugb25seSBmb3IgdGhlIGludGVuZGVkIHB1cnBvc2UgaW4gY29tcGxpYW5jZSBvZiB0
aGUgcmVseWluZyBwYXJ0eSBvYmxpZ2F0aW9ucy4wgZwGCCsGAQUFBwICMIGPMCcWIFN0YXJ0
Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MAMCAQIaZExpYWJpbGl0eSBhbmQgd2FycmFu
dGllcyBhcmUgbGltaXRlZCEgU2VlIHNlY3Rpb24gIkxlZ2FsIGFuZCBMaW1pdGF0aW9ucyIg
b2YgdGhlIFN0YXJ0Q29tIENBIHBvbGljeS4wNgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2Ny
bC5zdGFydHNzbC5jb20vY3J0dTItY3JsLmNybDCBjgYIKwYBBQUHAQEEgYEwfzA5BggrBgEF
BQcwAYYtaHR0cDovL29jc3Auc3RhcnRzc2wuY29tL3N1Yi9jbGFzczIvY2xpZW50L2NhMEIG
CCsGAQUFBzAChjZodHRwOi8vYWlhLnN0YXJ0c3NsLmNvbS9jZXJ0cy9zdWIuY2xhc3MyLmNs
aWVudC5jYS5jcnQwIwYDVR0SBBwwGoYYaHR0cDovL3d3dy5zdGFydHNzbC5jb20vMA0GCSqG
SIb3DQEBBQUAA4IBAQAWDJnVeIEl30sEHVyZ43IOK1RrYRyNJFAoClulBqL229p3whd4mtCY
hE25avnoZIMPTxhjZJlnmIlr0Ahh8hjSeqzjeEIVzBV//vVRBwI1DnaJ2u965og2FBhp3KXc
5pIHJA6aqJFqZE8EoI+81gdPB9Rc4cDAa0S4Bd4YtsLFfmxgR33EPC0MhEkwE2cihRTbF5Ye
yW1j4sUmnaJKlv9mxAs79D6n3Ggx8YBAOnkmg/tCTbTrJcqrB67NUpFhEcgFNRNqaL2oxE3u
qO7IjtyOzIlD+5dOJragt5dJJjXZF3NqWjsohcyYMECY8WEKUJlE0lPFQ4bPNfzWWdh16ooV
MYID2jCCA9YCAQEwgZMwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQu
MSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQD
Ey9TdGFydENvbSBDbGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQQICHn8w
CQYFKw4DAhoFAKCCAhswGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMTIwODEzMTUwMzI0WjAjBgkqhkiG9w0BCQQxFgQUadpQc3t0yG9D7zh16tSZACVy690w
bAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMH
MA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIB
KDCBpAYJKwYBBAGCNxAEMYGWMIGTMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRD
b20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4
MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMiBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQg
Q0ECAh5/MIGmBgsqhkiG9w0BCRACCzGBlqCBkzCBjDELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDIgUHJpbWFyeSBJbnRlcm1lZGlhdGUg
Q2xpZW50IENBAgIefzANBgkqhkiG9w0BAQEFAASCAQCiIrm6sT27qCPA8C6k0bAigQlW8A22
oV6tFELe2Qz/fYNYxk/iXDZTRgKJgFq2y/BYNCcvhqzvHKVGzUPC5ee7OKyvwn9p5xR3xA/V
uNA2LIchjyEW3jsyNPmcq6T7PrUaXaboaKGp+1Y8UmZctcrkRypuOStYt+hCY9vh3pr8O8Lr
VU2+gdugTGHwYC97KDKVbPkF+dxwd4XEsnCaT5ydHmhhlXVrbxVy17IQsD0kFAKaBuu2/N0+
bFKVdUz41Wn83j9U/2Aa8ZKFIzF6hhUSMYHHlkSNOTuThcac5NyOuYJ1OgxVdr/R+kP/9F3H
r+8gr8FjHEhz4uqiQU9wYujbAAAAAAAA
--------------ms030904050005020508020405--
